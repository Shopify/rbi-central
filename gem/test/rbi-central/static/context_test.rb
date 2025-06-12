# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module Static
    class ContextTest < Test
      def test_init_gemfile
        gem = Gem.new(name: "gem")
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)

        gem_names = T.must(context.read_gemfile)
          .lines
          .filter_map do |line|
            line.match(/gem ['"](?<gem_name>[^'"]*?)['"]/)&.named_captures&.fetch("gem_name")
          end

        assert_equal(["gem", "sorbet", "tapioca"], gem_names)
      end

      def test_init_requires_rb
        gem = Gem.new(name: "gem")
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)
        assert_equal(<<~RB, context.read("requires.rb"))
          require "gem"
        RB
      end

      def test_init_requires_rb_custom
        gem = Gem.new(name: "gem", requires: ["dep2", "dep1"])
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi", color: false)
        assert_equal(<<~RB, context.read("requires.rb"))
          require "dep2"
          require "dep1"
        RB
      end
    end
  end
end
