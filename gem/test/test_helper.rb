# typed: strict
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require "rbi-central"
require "minitest/test"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new(color: true))

module RBICentral
  class Repo
    extend T::Sig

    sig { params(command: String).returns(Spoom::ExecResult) }
    def repo(command)
      command = "#{command} --no-color" unless command.include?("--color")
      bundle_exec("repo #{command}")
    end

    sig { params(json: String).void }
    def write_index!(json)
      write!(index_path, json)
    end

    sig { params(gem_name: String, rbi: String).void }
    def write_annotations_file!(gem_name, rbi)
      write!("#{annotations_path}/#{gem_name}.rbi", rbi)
    end

    sig { override.params(branch: T.nilable(String)).returns(Spoom::ExecResult) }
    def git_init!(branch: "main")
      super
      git("config user.name 'test'")
      git("config user.email 'test@shopify.com'")
    end

    sig { params(name: String).returns(Spoom::ExecResult) }
    def git_create_and_checkout_branch!(name)
      git("checkout -b #{name}")
    end

    sig { returns(String) }
    def gems_path
      "gems/"
    end

    sig { params(name: String, version: String).returns(MockGem) }
    def add_mock_gem(name, version: "0.0.1")
      mock = MockGem.new("#{absolute_path}/#{gems_path}/#{name}", name, version: version)
      mock.mkdir!
      mock.gemspec!(mock.default_gemspec)
      mock.write!("lib/#{name}.rb", "module #{name.capitalize}; end")
      add_gem_dependency(name, path: mock.absolute_path)
      mock
    end

    sig do
      params(
        name: String,
        version: T.nilable(String),
        github: T.nilable(String),
        branch: T.nilable(String),
        ref: T.nilable(String),
        path: T.nilable(String)
      ).void
    end
    def add_gem_dependency(name, version: nil, github: nil, branch: nil, ref: nil, path: nil)
      line = String.new
      line << "gem '#{name}'"
      line << ", '#{version}'" if version
      line << ", github: '#{github}'" if github
      line << ", branch: '#{branch}'" if branch
      line << ", ref: '#{ref}'" if ref
      line << ", path: '#{path}'" if path
      line << "\n"
      write_gemfile!(line, append: true)
    end
  end

  class Test < Minitest::Test
    extend T::Sig

    GEM_ROOT = T.let(File.dirname(T.must(__dir__)), String)

    sig { params(messages: T::Array[String], errors: T::Array[Error]).void }
    def assert_messages(messages, errors)
      assert_equal(messages, errors.map(&:message))
    end
  end

  class MockGem < Spoom::Context
    extend T::Sig

    sig { returns(String) }
    attr_reader :name

    sig { params(absolute_path: String, name: String, version: String).void }
    def initialize(absolute_path, name, version: "0.0.1")
      super(absolute_path)
      @name = name
      @version = version
    end

    sig { params(gemspec_string: String, append: T::Boolean).void }
    def gemspec!(gemspec_string, append: false)
      write!("#{@name}.gemspec", gemspec_string, append: append)
    end

    sig { returns(String) }
    def default_gemspec
      <<~GEMSPEC
        Gem::Specification.new do |spec|
          spec.name          = "#{@name}"
          spec.version       = "#{@version}"
          spec.authors       = ["Test"]
          spec.email         = ["test@shopify.com"]
          spec.summary       = "Some description"
          spec.require_paths = ["lib"]
          spec.files         = Dir.glob("lib/**/*.rb")
        end
      GEMSPEC
    end

    sig { returns(Gem) }
    def gem
      Gem.new(name: @name, path: absolute_path)
    end
  end

  class TestWithRepo < Test
    extend T::Sig

    # TODO: replace with `setup` once Sorbet understands it
    sig { params(name: T.untyped).void }
    def initialize(name)
      super(name)
      @repo = T.let(Repo.mktmp!, Repo)
      @repo.write_gemfile!(<<~GEMFILE)
        source 'https://rubygems.org'

        gem "rbi-central", path: "#{GEM_ROOT}"
      GEMFILE
      @repo.bundle_install!
    end

    sig { void }
    def teardown
      @repo.destroy!
    end

    sig { params(string: String).returns(String) }
    def censor_rbi_version(string)
      string.gsub(/@.*\.rbi/, "@<VERSION>.rbi")
    end
  end
end
