# typed: strict
# frozen_string_literal: true

module RBICentral
  class Context < Spoom::Context
    extend T::Sig
    extend T::Helpers

    abstract!

    class Error < RBICentral::Error; end

    sig { params(gem: Gem, annotations_file: String).void }
    def initialize(gem, annotations_file)
      super(Dir.mktmpdir)

      @gem = gem
      init!
    end

    sig { void }
    def init!
      gemfile!(<<~GEMFILE)
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

      bundle("config set --local path 'vendor/bundle'")
    end

    sig { returns(T::Array[Error]) }
    def run!
      res = bundle_install!
      unless res.status
        return [Error.new("Can't install gem `#{@gem.name}` (#{res.err.gsub(/\n/, "")})")]
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
      gemfile!(line, append: true)
    end
  end
end
