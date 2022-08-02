# typed: strict
# frozen_string_literal: true

module RBICentral
  module CLI
    module Helper
      extend T::Sig
      extend T::Helpers
      include Spoom::Colorize

      requires_ancestor { Thor }

      sig { returns(Repo) }
      def repo
        # TODO: pass paths options
        @repo ||= T.let(Repo.new("."), T.nilable(Repo))
      end

      sig { params(block: T.proc.void).returns(T::Boolean) }
      def run_check!(&block)
        block.call
        $stderr.puts
        true
      rescue Thor::Error
        false
      end

      sig do
        params(
          block: T.proc.returns(T::Array[Error])
        ).void
      end
      def check_errors!(&block)
        errors = block.call
        if errors.empty?
          success("No errors, good job!")
        else
          errors.each do |error|
            error(error.message)
          end
          $stderr.puts
          raise Thor::Error, red("Some checks failed. See above for details.")
        end
      rescue Error => error
        raise Thor::Error, red(error.message)
      end

      sig do
        params(
          names: T::Array[String],
          block: T.proc.params(repo: Repo, gem: Gem).returns(T::Array[Error])
        ).void
      end
      def check_gems!(names:, &block)
        success = T.let(true, T::Boolean)

        repo = self.repo
        gems = repo.index.target_gems(names)

        last_gem_had_errors = T.let(false, T::Boolean)
        gems.each do |gem|
          errors = block.call(repo, gem)
          if errors.any?
            success = false
            $stderr.puts
            errors.each do |error|
              error(error.message)
            end
            $stderr.puts
            last_gem_had_errors = true
          else
            last_gem_had_errors = false
          end
        end

        $stderr.puts if gems.any? && !last_gem_had_errors

        if success
          success("No errors, good job!")
        else
          raise Thor::Error, red("Some checks failed. See above for details.")
        end
      end

      # Logging

      sig { params(message: String).void }
      def section(message)
        $stderr.puts(bold(blue("### #{message}")))
        $stderr.puts
      end

      sig { params(message: String).void }
      def error(message)
        $stderr.print(red("Error"))
        $stderr.print(": ")
        $stderr.puts(highlight(message, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::YELLOW))
      end

      sig { params(message: String).void }
      def log(message)
        $stderr.puts(highlight(message, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::BLUE))
      end

      sig { params(message: String).void }
      def success(message)
        $stderr.puts(green(message))
      end

      # Colors

      sig { returns(T::Boolean) }
      def color?
        options[:color]
      end

      sig { params(string: String, default_color: Spoom::Color, highlight_color: Spoom::Color).returns(String) }
      def highlight(string, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::BLUE)
        return string unless color?

        color = default_color
        out = String.new
        buffer = String.new

        string.chars.each do |char|
          if char == "`"
            out << set_color(buffer, color)
            buffer = String.new
            color = color == default_color ? highlight_color : default_color
          else
            buffer << char
          end
        end
        out << set_color(buffer, color)

        out
      end

      sig { params(string: ::String, color: ::Spoom::Color).returns(::String) }
      def set_color(string, *color)
        return string unless color?

        super
      end

      sig { params(string: String).returns(String) }
      def bold(string)
        set_color(string, Spoom::Color::BOLD)
      end

      sig { params(string: String).returns(String) }
      def blue(string)
        set_color(string, Spoom::Color::BLUE)
      end

      sig { params(string: String).returns(String) }
      def green(string)
        set_color(string, Spoom::Color::GREEN)
      end

      sig { params(string: String).returns(String) }
      def red(string)
        set_color(string, Spoom::Color::RED)
      end

      sig { params(string: String).returns(String) }
      def yellow(string)
        set_color(string, Spoom::Color::YELLOW)
      end
    end
  end
end
