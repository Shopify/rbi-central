# typed: strict
# frozen_string_literal: true

module RBICentral
  class Context < Spoom::Context
    extend T::Sig
    extend T::Helpers

    abstract!

    class Error < RBICentral::Error; end

    sig { params(gem: Gem, annotations_file: String, bundle_config: T::Hash[String, String]).void }
    def initialize(gem, annotations_file, bundle_config: {})
      super(Dir.mktmpdir)

      @gem = gem
      @bundle_config = bundle_config
      init!
    end

    sig { void }
    def init!
      write_gemfile!(<<~GEMFILE)
        source "https://rubygems.org"
      GEMFILE

      add_gem_dependency(@gem.name, path: @gem.path, source: @gem.source)
      @gem.dependencies.sort.each do |dep_name|
        add_gem_dependency(dep_name)
      end

      if @gem.requires.empty?
        add_require(@gem.name)
      else
        @gem.requires.each do |require_name|
          add_require(require_name)
        end
      end

      @bundle_config.each do |key, value|
        bundle("config set --local #{key} #{value}")
      end
    end

    sig { returns(T::Array[Error]) }
    def run!
      res = bundle_install!
      unless res.status
        return [Error.new("Can't install gem `#{@gem.name}` (#{T.must(res.err).strip.gsub("\n", " ")})")]
      end

      []
    end

    sig { abstract.params(name: String).void }
    def add_require(name); end

    sig do
      params(
        name: String,
        version: T.nilable(String),
        github: T.nilable(String),
        branch: T.nilable(String),
        ref: T.nilable(String),
        path: T.nilable(String),
        source: T.nilable(String),
      ).void
    end
    def add_gem_dependency(name, version: nil, github: nil, branch: nil, ref: nil, path: nil, source: nil)
      line = String.new
      line << "gem '#{name}'"
      line << ", '#{version}'" if version
      line << ", github: '#{github}'" if github
      line << ", branch: '#{branch}'" if branch
      line << ", ref: '#{ref}'" if ref
      line << ", path: '#{path}'" if path
      line << ", source: '#{source}'" if source
      line << "\n"
      write_gemfile!(line, append: true)
    end

    private

    sig { params(gem_name: String, annotations_file: String).returns(String) }
    def filter_versions_from_annotation(gem_name, annotations_file)
      gem_version = ::Gem::Version.new(gem_version_from_gemfile_lock(gem_name))
      rbi = RBI::Parser.parse_file(annotations_file)
      rbi.filter_versions!(gem_version)

      rbi.string
    end
  end
end
