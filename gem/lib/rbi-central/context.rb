# typed: strict
# frozen_string_literal: true

module RBICentral
  class Context
    extend T::Sig
    extend T::Helpers
    include CLI::Helper

    abstract!

    sig { params(gem_name: String, annotations_file: String).void }
    def initialize(gem_name, annotations_file)
      @workdir = T.let(Dir.mktmpdir, String)
      @gem_name = gem_name
      @annotations_file = annotations_file
      @gemfile = T.let(String.new, String)
    end

    sig { void }
    def destroy!
      FileUtils.rm_rf(@workdir)
    end

    sig { returns(T::Boolean) }
    def run!
      write_gemfile!

      out, status = bundle_install!
      unless status.success?
        error("Can't install gem `#{@gem_name}` (#{out.gsub(/\n/, "")})")
        return false
      end

      true
    end

    sig do
      params(
        name: String,
        version: T.nilable(String),
        github: T.nilable(String),
        branch: T.nilable(String),
        ref: T.nilable(String)
      ).void
    end
    def add_gem_dependency(name, version: nil, github: nil, branch: nil, ref: nil)
      @gemfile << "gem '#{name}'"
      @gemfile << ", '#{version}'" if version
      @gemfile << ", github: '#{github}'" if github
      @gemfile << ", branch: '#{branch}'" if branch
      @gemfile << ", ref: '#{ref}'" if ref
      @gemfile << "\n"
    end

    private

    sig { void }
    def write_gemfile!
      File.write("#{@workdir}/Gemfile", <<~GEMFILE)
        source "https://rubygems.org"

        #{@gemfile}
      GEMFILE
    end

    sig { returns([String, Process::Status]) }
    def bundle_install!
      exec!("bundle config set --local path 'vendor/bundle'")
      exec!("bundle install --quiet")
    end

    sig { params(command: String).returns([String, Process::Status]) }
    def exec!(command)
      Bundler.with_unbundled_env do
        T.unsafe(Open3).capture2e(command, chdir: @workdir)
      end
    end
  end
end
