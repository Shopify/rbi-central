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
        @repo ||= T.let(Repo.new(".", bundle_config: options[:bundle_config]), T.nilable(Repo))
      end

      sig { params(gem_names: T::Array[String], options: T::Hash[Symbol, T.untyped]).returns(ChecksSelection) }
      def select_checks(gem_names, options)
        checks = ChecksSelection.from_options(options)

        if options[:all]
          checks.gem_tests &= true
          checks.index &= true
          checks.rubocop &= true
          checks.rubygems &= true
          checks.runtime &= true
          checks.static &= true
          return checks
        end

        if gem_names.any?
          checks.index &= true
          checks.rubocop &= true
          checks.rubygems &= true
          checks.runtime &= true
          checks.static &= true
          return checks
        end

        checks.changed_files = repo.changed_files(ref: options[:ref])

        if checks.changed_files.empty?
          checks.gem_tests = false
          checks.index = false
          checks.rubocop = false
          checks.rubygems = false
          checks.runtime = false
          checks.static = false
          return checks
        end

        if checks.changed_files.any? { |file| file.match?(%r{^gem/.*}) }
          checks.gem_tests = true
          checks.index &= true
          checks.rubocop &= true
          checks.rubygems &= true
          checks.runtime &= true
          checks.static &= true
          return checks
        end

        if checks.changed_files.include?("Gemfile") || checks.changed_files.include?("Gemfile.lock")
          checks.gem_tests = false
          checks.index &= true
          checks.rubocop &= true
          checks.rubygems &= true
          checks.runtime &= true
          checks.static &= true
          return checks
        end

        checks.gem_tests = false

        unless checks.changed_files.include?(repo.index_path)
          checks.index = false
        end

        checks.changed_annotations = checks.changed_files
          .select { |file| file.match?(%r{#{repo.annotations_path}/.*.rbi}) }
          .map { |file| File.basename(file, ".rbi") }
          .sort

        if checks.changed_annotations.empty?
          checks.rubocop = false
          checks.rubygems = false
          checks.runtime = false
          checks.static = false
        end

        checks
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

      class ChecksSelection < T::Struct
        extend T::Sig

        prop :changed_files, T::Array[String], default: []
        prop :changed_annotations, T::Array[String], default: []
        prop :gem_tests, T::Boolean
        prop :index, T::Boolean
        prop :rubocop, T::Boolean
        prop :rubygems, T::Boolean
        prop :runtime, T::Boolean
        prop :static, T::Boolean

        sig { params(options: T::Hash[Symbol, T.untyped]).returns(ChecksSelection) }
        def self.from_options(options)
          ChecksSelection.new(
            gem_tests: options[:gem],
            index: options[:index],
            rubocop: options[:rubocop],
            rubygems: options[:rubygems],
            runtime: options[:runtime],
            static: options[:static],
          )
        end

        sig { returns(T::Boolean) }
        def any?
          gem_tests || index || rubocop || rubygems || runtime || static
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
