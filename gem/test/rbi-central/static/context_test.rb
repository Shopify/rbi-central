# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module Static
    class ContextTest < Test
      def test_init_gemfile
        gem = Gem.new(name: "gem")
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)
        assert_equal(<<~GEMFILE, context.read_gemfile)
          source \"https://rubygems.org\"
          gem 'gem'
          gem 'sorbet', '>= 0.5.10109'
          gem 'tapioca', '>= 0.9.2'
        GEMFILE
      end

      def test_init_requires_rb
        gem = Gem.new(name: "gem")
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)
        assert_equal(<<~RB, context.read("requires.rb"))
          require "gem"
        RB
      end

      def test_init_requires_rb_custom
        gem = Gem.new(name: "gem", requires: ["dep2", "dep1"])
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)
        assert_equal(<<~RB, context.read("requires.rb"))
          require "dep2"
          require "dep1"
        RB
      end
    end
  end
end
