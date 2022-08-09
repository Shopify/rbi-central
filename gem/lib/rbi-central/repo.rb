# typed: strict
# frozen_string_literal: true

module RBICentral
  class Repo < Spoom::Context
    extend T::Sig

    sig { returns(String) }
    attr_reader :index_path, :annotations_path

    sig { returns(T::Hash[String, T.untyped]) }
    attr_reader :index_schema

    class Error < RBICentral::Error; end

    sig do
      params(
        absolute_path: String,
        index_schema: T::Hash[String, T.untyped],
        index_path: String,
        annotations_path: String,
        bundle_config: T::Hash[String, String]
      ).void
    end
    def initialize(
      absolute_path,
      index_schema: INDEX_SCHEMA,
      index_path: INDEX_PATH,
      annotations_path: ANNOTATIONS_PATH,
      bundle_config: {}
    )
      super(absolute_path)
      @index_schema = index_schema
      @index_path = index_path
      @annotations_path = annotations_path
      @bundle_config = bundle_config
    end

    sig { returns(Index) }
    def index
      @index ||= T.let(load_index, T.nilable(Index))
    end

    sig { returns(T::Array[String]) }
    def annotations_files
      glob("#{@annotations_path}/*.rbi")
    end

    sig { params(gem: Gem).returns(String) }
    def annotations_file_for(gem)
      "#{ANNOTATIONS_PATH}/#{gem.name}.rbi"
    end

    sig { params(gems: T::Array[Gem]).returns(T::Array[String]) }
    def annotations_files_for(gems)
      gems.map { |gem| annotations_file_for(gem) }
    end

    sig { returns(T::Array[Index::Error]) }
    def check_index
      errors = T.let([], T::Array[Index::Error])
      errors.concat(check_missing_index_entries)
      errors.concat(check_missing_annotations_files)
      errors.concat(check_index_format)
      errors
    rescue Index::Error => error
      [error]
    end

    sig { returns(T::Array[Index::Error]) }
    def check_index_format
      errors = T.let([], T::Array[Index::Error])
      tmp_file = Tempfile.new("expected")
      tmp_path = T.must(tmp_file.path)
      tmp_file.write(index.to_formatted_json)
      tmp_file.rewind

      res = exec("diff -u \"#{tmp_path}\" \"#{index_path}\"")
      unless res.status
        err = res.out.lines
        err[0] = "--- expected\n"
        err[1] = "+++ #{index_path}\n"
        errors << Index::Error.new("Formatting errors found in `#{@index_path}`:\n#{err.join}")
      end

      errors
    ensure
      tmp_file&.close
      tmp_file&.unlink
    end

    sig { returns(T::Array[Index::Error]) }
    def check_missing_index_entries
      errors = T.let([], T::Array[Index::Error])

      annotations_files.each do |path|
        name = File.basename(path, ".rbi")
        next if index.gems.key?(name)

        errors << Index::Error.new(
          "Missing index entry for `#{path}` (key `#{name}` not found in `#{@index_path}`)"
        )
      end

      errors
    end

    sig { returns(T::Array[Gem::Error]) }
    def check_missing_annotations_files
      errors = T.let([], T::Array[Gem::Error])

      index.gems.keys.sort.each do |gem_name|
        file = "#{@annotations_path}/#{gem_name}.rbi"
        next if file?(file)

        errors << Gem::Error.new(
          "Missing RBI annotations file for `#{gem_name}` (file `#{file}` not found)"
        )
      end

      errors
    end

    sig { params(gem: Gem, color: T::Boolean).returns(T::Array[Gem::Error]) }
    def check_rubocop_for(gem, color: false)
      config_file = Tempfile.new(".rubocop.yml")
      config_file.write(RUBOCOP_CONFIG)
      config_file.close

      color_opt = color ? "--color" : "--no-color"
      res = bundle_exec("rubocop #{color_opt} -f clang #{annotations_file_for(gem)} -c #{config_file.path} >&2")
      return [] if res.status

      message = RBICentral.filter_parser_warning(res.err).lines[0..-3]&.join
      # TODO: parse errors lines
      [Gem::Error.new(message)]
    ensure
      config_file&.close
      config_file&.unlink
    end

    sig { params(gem: Gem).returns(T::Array[Gem::Error]) }
    def check_rubygems_for(gem)
      return [] if gem.belongs_to_rubygems?

      [Gem::Error.new(<<~ERROR)]
        `#{gem.name}` doesn't seem to be a public
           Make sure your gem is available at https://rubygems.org/gems/#{gem.name}
      ERROR
    end

    sig { params(gem: Gem, color: T::Boolean).returns(T::Array[Static::Context::Error]) }
    def check_static_for(gem, color:)
      annotations_file = annotations_file_for(gem)
      context = Static::Context.new(gem, annotations_file, color: color, bundle_config: @bundle_config)
      context.run!
    end

    sig { params(gem: Gem).returns(T::Array[Runtime::Context::Error]) }
    def check_runtime_for(gem)
      annotations_file = annotations_file_for(gem)
      rbi_tree = RBI::Parser.parse_file(annotations_file)
      context = Runtime::Context.new(gem, annotations_file, bundle_config: @bundle_config)
      visitor = Runtime::Visitor.new(context)
      visitor.visit(rbi_tree)
      errors = T.let([], T::Array[Runtime::Context::Error])
      errors.concat(visitor.errors)
      errors.concat(context.run!)
      errors
    rescue RBI::ParseError => e
      [Runtime::Context::Error.new("Can't parse RBI file `#{annotations_file}`: #{e.message}")]
    end

    sig { params(ref: String).returns(T::Array[String]) }
    def changed_files(ref: "HEAD")
      files = []

      res = git("ls-files --others --exclude-standard")
      raise Error, res.err unless res.status

      files.concat(res.out.lines.map(&:strip))
      res = git("diff --name-only #{ref} --")
      raise Error, res.err unless res.status

      files.concat(res.out.lines.map(&:strip))
      files.sort
    end

    sig { params(ref: String).returns(T::Array[String]) }
    def changed_annotations(ref: "HEAD")
      changed_files(ref: ref)
        .select { |file| file.match?(%r{#{annotations_path}/.*.rbi}) }
        .map { |file| File.basename(file, ".rbi") }
        .sort
    end

    sig { params(ref: String).returns(T::Boolean) }
    def index_changed?(ref: "HEAD")
      changed_files(ref: ref).include?(@index_path)
    end

    private

    sig { returns(Index) }
    def load_index
      json = read(@index_path)
      object = JSON.parse(json)
      JSON::Validator.validate!(index_schema, object)
      Index.from_object(object)
    rescue Errno::ENOENT
      raise Index::Error, "Missing index file `#{@index_path}`"
    rescue JSON::ParserError => e
      raise Index::Error, "Invalid JSON in `#{@index_path}`: #{e.message.sub(/^[0-9]+: /, "")}"
    rescue JSON::Schema::ValidationError => e
      raise Index::Error, e.message.gsub("'", "`")
    end
  end
end
