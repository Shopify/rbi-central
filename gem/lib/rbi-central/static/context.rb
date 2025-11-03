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

        add_gem_dependency("sorbet",  version: "= #{::Gem.loaded_specs["sorbet"].version}")
        add_gem_dependency("tapioca", version: "= #{::Gem.loaded_specs["tapioca"].version}")
      end

      sig { override.returns(T::Array[RBICentral::Context::Error]) }
      def run!
        errors = super
        return errors if errors.any?

        filtered_rbi = filter_versions_from_annotation(@gem.name, @annotations_file)

        # Write the filtered annotation to the context folder
        write!(@annotations_file, filtered_rbi)

        flags = "--no-doc --post requires.rb"
        flags += " --no-exported-gem-rbis" if @gem.skip_exported_rbis

        res = bundle_exec("tapioca gem #{flags}")
        unless res.status
          errors << Error.new(T.must(res.err).lstrip)
          return errors
        end

        res = bundle_exec("tapioca check-shims --no-payload " \
          "--gem-rbi-dir=sorbet/rbi/gems " \
          "--shim-rbi-dir=rbi/annotations " \
          "--annotations-rbi-dir=sorbet/rbi/none")
        unless res.status
          out = T.must(res.err)
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
          "--ignore vendor/bundle --no-config --no-error-count " \
          "--suppress-payload-superclass-redefinition-for=Reline::ANSI")
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
