# typed: strict
# frozen_string_literal: true

module RBICentral
  module CLI
    module Helper
      extend T::Sig
      extend T::Helpers
      include Spoom::Colorize

      requires_ancestor { Kernel }

      @color = T.let(true, T::Boolean)

      sig { returns(T::Boolean) }
      def self.color?
        @color
      end

      sig { params(value: T::Boolean).void }
      def self.color=(value)
        @color = value
      end

      sig { params(string: String, color: Spoom::Color).returns(String) }
      def set_color(string, *color)
        return string unless Helper.color?

        super
      end

      sig { params(string: String, default_color: Spoom::Color, highlight_color: Spoom::Color).returns(String) }
      def highlight(string, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::BLUE)
        return string unless Helper.color?

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

      sig { params(message: String).void }
      def error(message)
        $stderr.print("Error".red)
        $stderr.print(": ")
        $stderr.puts(highlight(message, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::YELLOW))
      end

      sig { params(message: String).void }
      def log(message)
        $stderr.puts(highlight(message, default_color: Spoom::Color::WHITE, highlight_color: Spoom::Color::BLUE))
      end

      sig { params(message: String).void }
      def success(message)
        $stderr.puts(message.green)
      end

      sig { returns(T::Hash[String, T.untyped]) }
      def load_index
        JSON.parse(File.read(INDEX_PATH))
      rescue => e
        error("Can't load index `#{INDEX_PATH}`")
        $stderr.puts("\n#{e.message}\n")
        exit(1)
      end

      sig { params(block: T.proc.returns(T::Boolean)).void }
      def check_success!(&block)
        raise Thor::Error, "Some checks failed. See above for details.".red unless block.call

        success("No errors, good job!")
      end

      sig do
        params(
          files: T::Array[String],
          block: T.proc.params(gem_name: String, annotations_file: String).returns(T::Boolean)
        ).returns(T::Boolean)
      end
      def check_gems(files:, &block)
        success = T.let(true, T::Boolean)

        targets = target_rbi_files(files)

        targets.each do |annotations_file|
          gem_name = File.basename(annotations_file, ".rbi")
          success &= block.call(gem_name, annotations_file)
        end

        $stderr.puts if targets.any?

        success
      end

      private

      sig { params(files: T::Array[String]).returns(T::Array[String]) }
      def target_rbi_files(files)
        files.empty? ? Dir.glob("./#{ANNOTATIONS_PATH}/*.rbi") : files
      end
    end
  end
end

class String
  extend T::Sig
  include RBICentral::CLI::Helper

  sig { returns(String) }
  def bold
    set_color(self, Spoom::Color::BOLD)
  end

  sig { returns(String) }
  def blue
    set_color(self, Spoom::Color::BLUE)
  end

  sig { returns(String) }
  def green
    set_color(self, Spoom::Color::GREEN)
  end

  sig { returns(String) }
  def red
    set_color(self, Spoom::Color::RED)
  end

  sig { returns(String) }
  def yellow
    set_color(self, Spoom::Color::YELLOW)
  end
end
