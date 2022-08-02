# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module Runtime
    class ContextTest < Test
      def test_init_requires
        gem = Gem.new(name: "gem")
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
        context.write_test!
        assert_includes(context.read(Context::TEST_NAME), <<~RB)
          begin
            require "gem"
          rescue LoadError => e
            $stderr.puts("Can't require `gem`")
            $success = false
          end
        RB
      end

      def test_init_requires_custom
        gem = Gem.new(name: "gem", requires: ["dep2", "dep1"])
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
        context.write_test!
        assert_includes(context.read(Context::TEST_NAME), <<~RB)
          begin
            require "dep2"
          rescue LoadError => e
            $stderr.puts("Can't require `dep2`")
            $success = false
          end
          begin
            require "dep1"
          rescue LoadError => e
            $stderr.puts("Can't require `dep1`")
            $success = false
          end
        RB
      end

      def test_add_constant
        gem = Gem.new(name: "gem")
        loc = RBI::Loc.new(file: "gem.rbi", begin_line: 1, begin_column: 2, end_line: 3, end_column: 4)
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
        context.add_constant("Foo", loc)
        context.write_test!
        assert_includes(context.read(Context::TEST_NAME), <<~RB)
          __rbi_repo_get_const("Foo", "gem.rbi:1:2-3:4")
        RB
      end

      def test_add_method
        gem = Gem.new(name: "gem")
        loc = RBI::Loc.new(file: "gem.rbi", begin_line: 1, begin_column: 2, end_line: 3, end_column: 4)
        context = Context.new(gem, "#{ANNOTATIONS_PATH}/gem.rbi")
        context.add_method("Foo", "foo", loc, allow_missing: true, singleton: true)
        context.add_method("Foo", "bar", loc, allow_missing: true, singleton: false)
        context.write_test!
        assert_includes(context.read(Context::TEST_NAME), <<~RB)
          __rbi_repo_get_method(
            "Foo",
            "foo",
            "gem.rbi:1:2-3:4",
            singleton: true,
            allow_missing: true
          )
          __rbi_repo_get_method(
            "Foo",
            "bar",
            "gem.rbi:1:2-3:4",
            singleton: false,
            allow_missing: true
          )
        RB
      end
    end
  end
end
