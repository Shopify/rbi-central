# typed: strict
# frozen_string_literal: true

module RBICentral
  module Static
    class Context < RBICentral::Context
      extend T::Sig

      sig { params(gem_name: String, annotations_file: String).void }
      def initialize(gem_name, annotations_file)
        super

        @requires = T.let(String.new, String)
      end

      sig { override.returns(T::Boolean) }
      def run!
        add_gem_dependency("sorbet", version: ">= 0.5.10109")
        add_gem_dependency("tapioca", github: "Shopify/tapioca", ref: "8ce7951f69aa41ce9ff4990b67f0c3c9d64c0a6f")
        add_gem_dependency(@gem_name)

        return false unless super

        write_require_rb!

        out, status = exec!("bundle exec tapioca gem --no-doc --post #{@workdir}/requires.rb")
        unless status.success?
          $stderr.puts("\n#{out}")
          return false
        end

        write_annotation_file!

        success = true
        out, status = exec!("bundle exec tapioca check-shims --no-payload " \
          "--gem-rbi-dir=#{@workdir}/sorbet/rbi/gems " \
          "--shim-rbi-dir=#{@workdir}/rbi/annotations " \
          "--annotations-rbi-dir=#{@workdir}/sorbet/rbi/none")
        unless status.success?
          out.gsub!("#{@workdir}/", "")
          out.gsub!("rbi/annotations and sorbet/rbi/todo.rbi", @annotations_file.yellow)

          out.lines do |line|
            if line.start_with?("Duplicated")
              error(line.strip)
            elsif line.start_with?(" * ")
              $stderr.puts(line.strip.yellow)
            end
          end

          success = false
        end

        out, status = exec!("bundle exec srb tc . " \
          "--no-error-sections --color=#{RBICentral::CLI::Helper.color? ? "always" : "never"} " \
          "--ignore vendor/bundle --no-config --no-error-count")
        unless status.success?
          $stderr.puts(out)
          success = false
        end

        success
      ensure
        destroy!
      end

      sig { params(name: String).void }
      def add_require(name)
        @requires << <<~RB
          require "#{name}"
        RB
      end

      private

      sig { void }
      def write_require_rb!
        File.write("#{@workdir}/requires.rb", @requires)
      end

      sig { void }
      def write_annotation_file!
        FileUtils.mkdir_p("#{@workdir}/rbi/annotations")
        FileUtils.cp(@annotations_file, "#{@workdir}/#{@annotations_file}")
      end
    end
  end
end
