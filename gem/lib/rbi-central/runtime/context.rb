# typed: strict
# frozen_string_literal: true

module RBICentral
  module Runtime
    class Context < RBICentral::Context
      extend T::Sig

      TEST_NAME = "test.rb"

      class Error < RBICentral::Context::Error; end

      sig { params(gem: Gem, annotations_file: String, bundle_config: T::Hash[String, String]).void }
      def initialize(gem, annotations_file, bundle_config: {})
        @requires = T.let(String.new, String)
        @body = T.let(String.new, String)
        super(gem, annotations_file, bundle_config: bundle_config)
      end

      sig { override.returns(T::Array[RBICentral::Context::Error]) }
      def run!
        errors = T.let(super, T::Array[RBICentral::Context::Error])
        return errors if errors.any?

        write_test!

        res = bundle_exec("ruby #{TEST_NAME}")
        unless res.status
          out = T.must(res.err)
          error = T.let(nil, T.nilable(String))
          out.lines do |line|
            if line.start_with?("Note: ")
              T.must(error) << line
            else
              errors << Error.new(error.strip) if error
              error = String.new(line)
            end
          end
          errors << Error.new(error.strip) if error
          return errors
        end

        errors
      ensure
        destroy!
      end

      sig { override.params(name: String).void }
      def add_require(name)
        @requires << <<~RB
          begin
            require "#{name}"
          rescue LoadError => e
            $stderr.puts("Can't require `#{name}`")
            $success = false
          end
        RB
      end

      sig { params(const_name: String, loc: RBI::Loc).void }
      def add_constant(const_name, loc)
        @body << <<~RB
          __rbi_repo_get_const("#{const_name}", "#{loc}")
        RB
      end

      sig { params(const_name: String, superclass_name: T.nilable(String), loc: RBI::Loc).void }
      def add_class(const_name, superclass_name, loc)
        superclass = superclass_name ? "\"#{superclass_name}\"" : "nil"
        @body << <<~RB
          __rbi_repo_get_class("#{const_name}", #{superclass}, "#{loc}")
        RB
      end

      sig { params(const_name: String, loc: RBI::Loc).void }
      def add_module(const_name, loc)
        @body << <<~RB
          __rbi_repo_get_module("#{const_name}", "#{loc}")
        RB
      end

      sig { params(const_name: String, mixin_name: String, loc: RBI::Loc).void }
      def add_include(const_name, mixin_name, loc)
        @body << <<~RB
          __rbi_repo_get_include("#{const_name}", "#{mixin_name}", "#{loc}")
        RB
      end

      sig { params(const_name: String, mixin_name: String, loc: RBI::Loc).void }
      def add_extend(const_name, mixin_name, loc)
        @body << <<~RB
          __rbi_repo_get_extend("#{const_name}", "#{mixin_name}", "#{loc}")
        RB
      end

      sig do
        params(
          recv_name: String,
          method_name: String,
          loc: RBI::Loc,
          allow_missing: T::Boolean,
          singleton: T::Boolean,
        ).void
      end
      def add_method(recv_name, method_name, loc, allow_missing:, singleton: false)
        @body << <<~RB
          __rbi_repo_get_method(
            "#{recv_name}",
            "#{method_name}",
            "#{loc}",
            singleton: #{singleton},
            allow_missing: #{allow_missing}
          )
        RB
      end

      sig { void }
      def write_test!
        write!(TEST_NAME, ruby_string)
      end

      private

      sig { returns(String) }
      def ruby_string
        <<~RB
          $success = true

          def __rbi_repo_get_const(const_name, rbi_loc)
            Kernel.const_get("\#{const_name}")
          rescue NameError => e
            $stderr.puts("Missing runtime constant `\#{const_name}` (defined at `\#{rbi_loc}`)")
            $success = false
            nil
          end

          def __rbi_repo_get_class(const_name, superclass_name, rbi_loc)
            const = __rbi_repo_get_const(const_name, rbi_loc)
            return unless const

            unless const.is_a?(Class)
              $stderr.puts("Runtime constant `\#{const_name}` is not a class (defined at `\#{rbi_loc}`)")
              $success = false
              return
            end

            return unless superclass_name

            superclass = __rbi_repo_get_const(superclass_name, rbi_loc)
            return unless superclass

            unless const.superclass == superclass
              $stderr.puts("Runtime constant `\#{const_name}` is not a subclass of `\#{superclass}` found `\#{const.superclass}` (defined at `\#{rbi_loc}`)")
              $success = false
              nil
            end
          end

          def __rbi_repo_get_module(const_name, rbi_loc)
            const = __rbi_repo_get_const(const_name, rbi_loc)
            return unless const

            if const.is_a?(Class)
              $stderr.puts("Runtime constant `\#{const_name}` is not a module (defined at `\#{rbi_loc}`)")
              $success = false
              nil
            end
          end

          def __rbi_repo_get_include(const_name, mixin_name, rbi_loc)
            const = __rbi_repo_get_const(const_name, rbi_loc)
            return unless const

            mixin = __rbi_repo_get_const(mixin_name, rbi_loc)
            return unless mixin

            unless const.ancestors.include?(mixin)
              $stderr.puts("Runtime constant `\#{const_name}` does not include `\#{mixin}` (defined at `\#{rbi_loc}`)")
              $success = false
            end
          end

          def __rbi_repo_get_extend(const_name, mixin_name, rbi_loc)
            const = __rbi_repo_get_const(const_name, rbi_loc)
            return unless const

            mixin = __rbi_repo_get_const(mixin_name, rbi_loc)
            return unless mixin

            unless const.singleton_class.ancestors.include?(mixin)
              $stderr.puts("Runtime constant `\#{const_name}` does not extend `\#{mixin}` (defined at `\#{rbi_loc}`)")
              $success = false
            end
          end

          def __rbi_repo_get_method(recv_name, method_name, rbi_loc, singleton:, allow_missing:)
            const = __rbi_repo_get_const(recv_name, rbi_loc)
            return unless const

            if singleton
              const.method("\#{method_name}")
            else
              const.instance_method("\#{method_name}")
            end
          rescue NameError => e
            if const && __rbi_repo_respond_to_method_missing?(const, singleton: singleton)
              return if allow_missing

              $stderr.puts("Missing runtime method `\#{recv_name}\#{singleton ? "." : "#"}\#{method_name}` (defined at `\#{rbi_loc}`)")
              $stderr.puts("Note: `\#{method_name}` could be delegated to :method_missing but the RBI definition isn't annotated with `@method_missing`.")
              $success = false
              return nil
            end

            $stderr.puts("Missing runtime method `\#{recv_name}\#{singleton ? "." : "#"}\#{method_name}` (defined at `\#{rbi_loc}`)")
            $success = false
            nil
          end

          def __rbi_repo_respond_to_method_missing?(const, singleton:)
            method = if singleton
              const.singleton_method(:method_missing)
            else
              const.instance_method(:method_missing)
            end
            !/\\(BasicObject\\)/.match?(method.to_s)
          rescue NameError => e
            false
          end

          #{@requires}

          exit(1) unless $success

          #{@body}

          exit(1) unless $success
        RB
      end
    end
  end
end
