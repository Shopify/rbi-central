# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module Runtime
    class ContextTest < Test
      def test_require_error
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        context = Context.new(mock.gem, "foo.rbi")
        assert_messages(["Can't require `foo`"], context.run!)
      end

      def test_missing_constant
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          module Foo
            module Bar; end
          end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        visitor = Runtime::Visitor.new(context)
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          module Foo; end
          module Foo::Bar; end
          module Not::Found; end
        RBI
        visitor.visit(rbi_tree)
        assert_messages(["Missing runtime constant `::Not::Found` (defined at `-:3:0-3:22`)"], context.run!)
      end

      def test_missing_method
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          module Foo
            def foo; end
            class Bar
              def self.foo; end
            end
          end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        visitor = Runtime::Visitor.new(context)
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          module Foo
            def foo; end
            def bar; end
          end

          class Foo::Bar
            def self.foo; end
            def self.baz; end
          end
        RBI
        visitor.visit(rbi_tree)
        assert_messages([
          "Missing runtime method `::Foo#bar` (defined at `-:3:2-3:14`)",
          "Missing runtime method `::Foo::Bar.baz` (defined at `-:8:2-8:19`)",
        ], context.run!)
      end

      def test_wrong_kind
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          module Foo; end
          class Bar; end
          class Baz; end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          class Foo; end
          module Bar; end
          class Baz; end
        RBI
        visitor = Runtime::Visitor.new(context)
        visitor.visit(rbi_tree)
        assert_messages([
          "Runtime constant `::Foo` is not a class (defined at `-:1:0-1:14`)",
          "Runtime constant `::Bar` is not a module (defined at `-:2:0-2:15`)",
        ], context.run!)
      end

      def test_wrong_class_parent
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          class Foo; end
          class Bar < Foo; end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          class Foo < Integer; end
          class Foo < Object; end
          class Foo; end
          class Bar < Integer; end
          class Bar < Foo; end
          class Bar; end
        RBI
        visitor = Runtime::Visitor.new(context)
        visitor.visit(rbi_tree)
        assert_messages([
          "Runtime constant `::Foo` is not a subclass of `Integer` found `Object` (defined at `-:1:0-1:24`)",
          "Runtime constant `::Bar` is not a subclass of `Integer` found `Foo` (defined at `-:4:0-4:24`)",
        ], context.run!)
      end

      def test_wrong_includes
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          module Mixin1; end
          module Mixin2; end

          module Foo
            include Mixin1
          end

          module Bar
            include Mixin2
          end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          module Foo
            include Mixin1, Mixin2
            include Kernel
          end

          module Bar
            include Mixin2
          end
        RBI
        visitor = Runtime::Visitor.new(context)
        visitor.visit(rbi_tree)
        assert_messages([
          "Runtime constant `::Foo` does not include `Mixin2` (defined at `-:2:2-2:24`)",
          "Runtime constant `::Foo` does not include `Kernel` (defined at `-:3:2-3:16`)",
        ], context.run!)
      end

      def test_wrong_extends
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("lib/foo.rb", <<~RB)
          module Mixin1; end
          module Mixin2; end

          module Foo
            extend Mixin1
          end

          module Bar
            extend Mixin2
          end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          module Foo
            extend Mixin1, Mixin2
            extend Kernel
          end

          module Bar
            extend Mixin2
          end
        RBI
        visitor = Runtime::Visitor.new(context)
        visitor.visit(rbi_tree)
        assert_messages([
          "Runtime constant `::Foo` does not extend `Mixin2` (defined at `-:2:2-2:23`)",
        ], context.run!)
      end

      def test_can_use_sorbet_runtime
        mock = MockGem.new(Dir.mktmpdir, "foo")
        mock.gemspec!(mock.default_gemspec)
        mock.write!("#{mock.name}.gemspec", <<~RB)
          Gem::Specification.new do |spec|
            spec.name          = "#{mock.name}"
            spec.version       = "0.1.1"
            spec.authors       = ["Test"]
            spec.email         = ["test@shopify.com"]
            spec.summary       = "Some description"
            spec.require_paths = ["lib"]
            spec.files         = Dir.glob("lib/**/*.rb")

            spec.add_runtime_dependency("sorbet-runtime", ">= 0.5.10109")
          end
        RB
        mock.write!("lib/foo.rb", <<~RB)
          require "sorbet-runtime"

          module Foo
            extend T::Sig
            extend T::Helpers
            extend T::Generic

            def foo; end
          end
        RB
        context = Context.new(mock.gem, "gem.rbi")
        rbi_tree = RBI::Parser.parse_string(<<~RBI)
          module Foo
            extend T::Sig
            extend T::Helpers
            extend T::Generic

            sig {returns(T.self_type)}
            def foo; end

            def bar; end
          end
        RBI
        visitor = Runtime::Visitor.new(context)
        visitor.visit(rbi_tree)
        assert_messages(["Missing runtime method `::Foo#bar` (defined at `-:9:2-9:14`)"], context.run!)
      end
    end
  end
end
