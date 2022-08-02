# typed: strict
# frozen_string_literal: true

module RBICentral
  extend T::Sig

  RBIS_PATH = "rbi/annotations"

  class RBIValidator
    extend T::Sig
    extend T::Helpers
    extend CLI
    include CLI

    abstract!

    sig { params(repo_index: T::Hash[String, T.untyped], files: T::Array[String]).void }
    def self.validate_files!(repo_index, files)
      success = T.let(true, T::Boolean)

      files.each do |file|
        validator = new(repo_index, file)
        unless validator.validate_file!
          $stderr.puts("")
          success = false
        end
      end

      exit(1) unless success

      success("\nNo errors, good job!")
    end

    sig { params(repo_index: T::Hash[String, T.untyped], rbi_file: String).void }
    def initialize(repo_index, rbi_file)
      @repo_index = repo_index
      @rbi_file = rbi_file
      @gem_name = T.let(File.basename(rbi_file, ".rbi"), String)
    end

    sig { abstract.returns(T::Boolean) }
    def validate_file!; end
  end

  sig { returns(T::Array[String]) }
  def self.rbi_files
    ARGV.empty? ? Dir.glob("./#{RBIS_PATH}/*.rbi") : ARGV
  end
end
