# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  class ContextTest < Test
    class DummyContext < Context
      extend T::Sig

      sig { override.params(name: String).void }
      def add_require(name); end
    end

    def test_init_gemfile
      gem = Gem.new(name: "gem")
      context = DummyContext.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
      assert_equal(<<~GEMFILE, context.read_gemfile)
        source "https://rubygems.org"
        gem 'gem'
      GEMFILE
    end

    def test_init_gemfile_dependencies
      gem = Gem.new(name: "gem", dependencies: ["dep2", "dep1"])
      context = DummyContext.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
      assert_equal(<<~GEMFILE, context.read_gemfile)
        source "https://rubygems.org"
        gem 'gem'
        gem 'dep1'
        gem 'dep2'
      GEMFILE
    end

    def test_add_gem_dependency
      gem = Gem.new(name: "gem")
      context = DummyContext.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
      context.add_gem_dependency("dep1")
      context.add_gem_dependency("dep2", version: ">= 1.0.0")
      context.add_gem_dependency("dep3", github: "Shopify/gem", branch: "feature")
      assert_equal(<<~GEMFILE, context.read_gemfile)
        source "https://rubygems.org"
        gem 'gem'
        gem 'dep1'
        gem 'dep2', '>= 1.0.0'
        gem 'dep3', github: 'Shopify/gem', branch: 'feature'
      GEMFILE
    end

    def test_run_cant_bundle_install
      gem = Gem.new(name: "a-gem-that-does-not-exist")
      context = DummyContext.new(gem, "#{ANNOTATIONS_PATH}/a-gem-that-does-not-exist.rbi")
      errors = context.run!
      assert_equal(1, errors.size)
      assert_equal(<<~ERROR.strip, errors.first&.message)
        Can't install gem `a-gem-that-does-not-exist` (Could not find gem 'a-gem-that-does-not-exist' in rubygems repository https://rubygems.org/, cached gems or installed locally.)
      ERROR
    end

    def test_run_bundle_install
      repo = Repo.mktmp!
      mock = repo.add_mock_gem("gem1")
      gem = Gem.new(name: "gem1", path: mock.absolute_path)
      context = DummyContext.new(gem, "#{ANNOTATIONS_PATH}/gem1.rbi")
      errors = context.run!
      assert_empty(errors)
    end
  end
end
