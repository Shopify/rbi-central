# typed: strict
# frozen_string_literal: true

module RBICentral
  module Runtime
    class Context < RBICentral::Context
      extend T::Sig

      TEST_NAME = "test.rb"

      class Error < RBICentral::Context::Error; end

      sig { params(gem: Gem, annotations_file: String).void }
      def initialize(gem, annotations_file)
        @requires = T.let(String.new, String)
        @body = T.let(String.new, String)
        super(gem, annotations_file)
      end

      sig { override.returns(T::Array[Error]) }
      def run!
        errors = T.let(super, T::Array[Error])
        return errors if errors.any?

        write_test!

        res = bundle_exec("ruby #{TEST_NAME}")
        unless res.status
          out = res.err
          error = T.let(nil, T.nilable(String))
          out.lines do |line|
            if line.start_with?("Note: ")
              T.must(error) << line
            else
              errors << Error.new(error) if error
              error = String.new(line)
            end
          end
          errors << Error.new(error) if error
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

      sig do
        params(
          recv_name: String,
          method_name: String,
          loc: RBI::Loc,
          allow_missing: T::Boolean,
          singleton: T::Boolean
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

          def __rbi_repo_get_method(recv_name, method_name, rbi_loc, singleton:, allow_missing:)
            const = __rbi_repo_get_const(recv_name, rbi_loc)
            return unless const

            if singleton
              const.method("\#{method_name}")
            else
              const.instance_method("\#{method_name}")
            end
          rescue NameError => e
            if const && !singleton && __rbi_repo_respond_to_method_missing?(const)
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

          def __rbi_repo_respond_to_method_missing?(const)
            method = const.instance_method(:method_missing)
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
