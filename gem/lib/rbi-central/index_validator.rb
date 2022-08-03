# typed: strict
# frozen_string_literal: true

module RBICentral
  class IndexValidator
    extend T::Sig
    extend CLI::Helper
    include CLI::Helper

    EXPECTED_PATH = "expected"

    sig { params(index_path: String, schema_path: String, rbis_path: String).void }
    def initialize(index_path:, schema_path:, rbis_path:)
      @index_path = index_path
      @schema_path = schema_path
      @rbis_path = rbis_path

      @index_json = T.let(load_json(index_path), T::Hash[String, T.untyped])
      @schema_json = T.let(load_json(schema_path), T::Hash[String, T.untyped])
    end

    sig { returns(T::Boolean) }
    def validate!
      success = true
      success &= check_against_schema!
      success &= check_missing_index_entries!
      success &= check_missing_annotations!
      success &= check_json_format!
      success
    end

    private

    sig { returns(T::Boolean) }
    def check_against_schema!
      JSON::Validator.validate!(@schema_json, @index_json)
    rescue JSON::Schema::ValidationError => error
      error(error.message.gsub("'", "`"))
      false
    end

    sig { returns(T::Boolean) }
    def check_missing_annotations!
      success = T.let(true, T::Boolean)
      @index_json.each do |gem_name, _|
        file = "#{@rbis_path}/#{gem_name}.rbi"
        next if File.file?(file)

        error("Missing RBI annotations file for `#{gem_name}` (file `#{file}` not found)")
        success = false
      end
      success
    end

    sig { returns(T::Boolean) }
    def check_missing_index_entries!
      success = T.let(true, T::Boolean)
      rbis = Dir.glob("#{@rbis_path}/*.rbi").sort
      rbis.each do |path|
        name = File.basename(path, ".rbi")
        next if @index_json.key?(name)

        error("Missing index entry for `#{path}` (key `#{name}` not found in `#{@index_path}`)")
        success = false
      end
      success
    end

    sig { returns(T::Boolean) }
    def check_json_format!
      sorted = Hash[@index_json.sort]
      expected_json = JSON.pretty_generate(sorted) << "\n"
      File.write(EXPECTED_PATH, expected_json)

      out, status = Open3.capture2e("diff -u #{@index_path} #{EXPECTED_PATH}")
      unless status.success?
        error("Formatting errors found in `#{@index_path}`:")
        lines = out.lines
        lines[0] = "--- expected\n"
        lines[1] = "+++ #{@index_path}\n"
        $stderr.puts(lines.join + "\n")
        return false
      end

      true
    ensure
      FileUtils.rm(EXPECTED_PATH)
    end

    sig { params(path: String).returns(T::Hash[String, T.untyped]) }
    def load_json(path)
      JSON.parse(File.read(path))
    rescue JSON::ParserError => e
      error = e.message.sub(/^[0-9]+: /, "")
      error("Invalid JSON in #{path.yellow}:")
      $stderr.puts("\n#{error}\n")
      exit(1)
    end
  end
end
