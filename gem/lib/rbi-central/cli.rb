# typed: strict
# frozen_string_literal: true

module RBICentral
  module CLI
    extend T::Sig

    module Colors
      extend T::Sig
      extend self

      CLEAR           = "\e[0m"
      BOLD            = "\e[1m"

      BLACK           = "\e[30m"
      RED             = "\e[31m"
      GREEN           = "\e[32m"
      YELLOW          = "\e[33m"
      BLUE            = "\e[34m"
      MAGENTA         = "\e[35m"
      CYAN            = "\e[36m"
      WHITE           = "\e[37m"

      LIGHT_BLACK     = "\e[90m"
      LIGHT_RED       = "\e[91m"
      LIGHT_GREEN     = "\e[92m"
      LIGHT_YELLOW    = "\e[93m"
      LIGHT_BLUE      = "\e[94m"
      LIGHT_MAGENTA   = "\e[95m"
      LIGHT_CYAN      = "\e[96m"
      LIGHT_WHITE     = "\e[97m"

      sig { params(string: String, color: String).returns(String) }
      def set_color(string, *color)
        "#{color.join}#{string}#{CLEAR}"
      end

      sig { params(string: String, default_color: String, highlight_color: String).returns(String) }
      def highlight(string, default_color: WHITE, highlight_color: BLUE)
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
    end

    sig { params(message: String).void }
    def error(message)
      $stderr.print("Error".red)
      $stderr.print(": ")
      $stderr.puts(Colors.highlight(message, default_color: Colors::WHITE, highlight_color: Colors::YELLOW))
    end

    sig { params(message: String).void }
    def log(message)
      $stderr.puts(Colors.highlight(message, default_color: Colors::WHITE, highlight_color: Colors::BLUE))
    end

    sig { params(message: String).void }
    def success(message)
      $stderr.puts(message.green)
    end
  end
end

class String
  extend T::Sig
  include RBICentral::CLI::Colors

  sig { returns(String) }
  def bold
    set_color(self, RBICentral::CLI::Colors::BOLD)
  end

  sig { returns(String) }
  def blue
    set_color(self, RBICentral::CLI::Colors::BLUE)
  end

  sig { returns(String) }
  def green
    set_color(self, RBICentral::CLI::Colors::GREEN)
  end

  sig { returns(String) }
  def red
    set_color(self, RBICentral::CLI::Colors::RED)
  end

  sig { returns(String) }
  def yellow
    set_color(self, RBICentral::CLI::Colors::YELLOW)
  end
end
