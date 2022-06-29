require "open3"
require "tmpdir"

class Context
  def initialize(rbi_file, gem_name)
    @workdir = Dir.mktmpdir
    @rbi_file = rbi_file
    @gem_name = gem_name
    @gemfile = String.new
  end

  def destroy!
    FileUtils.rm_rf(@workdir)
  end

  def run!
    write_gemfile!

    out, status = bundle_install!
    unless status.success?
      $stderr.puts(" * Can't install gem `#{@gem_name}` (#{out.gsub(/\n/, "")})")
      return false
    end

    true
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

  def write_gemfile!
    File.write("#{@workdir}/Gemfile", <<~GEMFILE)
      source "https://rubygems.org"

      #{@gemfile}
    GEMFILE
  end

  def bundle_install!
    exec!("bundle config set --local path 'vendor/bundle'")
    exec!("bundle install --quiet")
  end

  def exec!(command)
    Bundler.with_unbundled_env do
      Open3.capture2e(command, chdir: @workdir)
    end
  end
end
