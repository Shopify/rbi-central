# typed: strict
# frozen_string_literal: true

module RBICentral
  module Static
    class Context < RBICentral::Context
      extend T::Sig

      class Error < RBICentral::Context::Error; end

      sig { params(gem: Gem, annotations_file: String, color: T::Boolean, bundle_config: T::Hash[String, String]).void }
      def initialize(gem, annotations_file, color:, bundle_config: {})
        @annotations_file = annotations_file
        @color = color
        super(gem, annotations_file, bundle_config: bundle_config)
      end

      sig { override.void }
      def init!
        super

        add_gem_dependency("sorbet", version: ">= 0.5.10109")
        add_gem_dependency("tapioca", version: ">= 0.9.2")
      end

      sig { override.returns(T::Array[Error]) }
      def run!
        errors = super
        return errors if errors.any?

        res = bundle_exec("tapioca gem --no-doc --post requires.rb")
        unless res.status
          errors << Error.new(res.err.lstrip)
          return errors
        end

        # Copy annotations file inside the context so path look relative
        FileUtils.mkdir_p("#{absolute_path}/rbi/annotations")
        FileUtils.cp(@annotations_file, "#{absolute_path}/#{@annotations_file}")

        res = bundle_exec("tapioca check-shims --no-payload " \
          "--gem-rbi-dir=sorbet/rbi/gems " \
          "--shim-rbi-dir=rbi/annotations " \
          "--annotations-rbi-dir=sorbet/rbi/none")
        unless res.status
          out = res.err
          out.gsub!("#{absolute_path}/", "")
          out.gsub!("rbi/annotations and sorbet/rbi/todo.rbi", @annotations_file)

          error = T.let(nil, T.nilable(String))
          out.lines do |line|
            if line.start_with?("Duplicated")
              errors << Error.new(error) if error
              error = String.new(line)
            elsif line.start_with?(" * ")
              T.must(error) << line
            end
          end
          errors << Error.new(error) if error
        end

        res = bundle_exec("srb tc . " \
          "--no-error-sections --color=#{@color ? "always" : "never"} " \
          "--ignore vendor/bundle --no-config --no-error-count")
        unless res.status
          errors << Error.new(res.err)
        end

        errors
      ensure
        destroy!
      end

      sig { override.params(name: String).void }
      def add_require(name)
        write!("requires.rb", <<~RB, append: true)
          require "#{name}"
        RB
      end
    end
  end
end
