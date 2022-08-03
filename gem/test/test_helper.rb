# typed: strict
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require "rbi-central"
require "minitest/test"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new(color: true))

module RBICentral
  class Repo < Spoom::Context
    extend T::Sig

    sig { returns(String) }
    attr_reader :index_path, :schema_path, :annotations_path, :rubocop_config_path

    sig { params(absolute_path: String).void }
    def initialize(absolute_path)
      super
      @index_path = T.let(INDEX_PATH, String)
      @schema_path = T.let(SCHEMA_PATH, String)
      @annotations_path = T.let(ANNOTATIONS_PATH, String)
      @rubocop_config_path = T.let(RUBOCOP_CONFIG_PATH, String)
    end

    sig { params(command: String).returns(Spoom::ExecResult) }
    def repo(command)
      command = "#{command} --no-color" unless command.include?("--color")
      exec("repo #{command}")
    end

    sig { params(json: String).void }
    def write_index!(json)
      write!(index_path, json)
    end

    sig { params(json: String).void }
    def write_schema!(json)
      write!(schema_path, json)
    end

    sig { params(gem_name: String, rbi: String).void }
    def write_annotations_file!(gem_name, rbi)
      write!("#{annotations_path}/#{gem_name}.rbi", rbi)
    end
  end

  class Test < Minitest::Test
    REAL_SCHEMA = T.let(File.read("#{__dir__}/../../schema.json"), String)
    REAL_RUBOCOP_CONFIG = T.let(File.read("#{__dir__}/../../.rubocop.yml"), String)
  end

  class TestWithRepo < Test
    extend T::Sig

    # TODO: replace with `setup` once SOrbet understands it
    sig { params(name: T.untyped).void }
    def initialize(name)
      super(name)
      @repo = T.let(Repo.mktmp!, Repo)
      @repo.write!(@repo.schema_path, REAL_SCHEMA)
      @repo.write!(@repo.rubocop_config_path, REAL_RUBOCOP_CONFIG)
    end

    sig { void }
    def teardown
      @repo.destroy!
    end
  end
end
