# typed: strict
# frozen_string_literal: true

module RBICentral
  module Runtime
    class Visitor < RBI::Visitor
      extend T::Sig
      include CLI::Helper

      sig { params(context: Runtime::Context).void }
      def initialize(context)
        super()
        @context = context
      end

      sig { override.params(node: T.nilable(RBI::Node)).void }
      def visit(node)
        return unless node

        validate_node!(node)
        visit_all(node.nodes) if node.is_a?(RBI::Tree)
      end

      sig { params(node: RBI::Node).void }
      def validate_node!(node)
        annotations = validate_annotations!(node)

        # Do not test definitions tagged `@shim`
        return if annotations.include?("shim")

        loc = T.must(node.loc)

        case node
        when RBI::Module, RBI::Class
          @context.add_constant(node.fully_qualified_name, loc)
        when RBI::Const
          return if node.value.start_with?("type_member") || node.value.start_with?("type_template")

          @context.add_constant(node.fully_qualified_name, loc)
        when RBI::Method
          scope = node.parent_scope
          scope_name = scope_name(scope)
          is_singleton = node.is_singleton || scope.is_a?(RBI::SingletonClass)
          allow_missing = annotations.include?("method_missing")

          @context.add_method(scope_name, node.name, loc, singleton: is_singleton, allow_missing: allow_missing)
        when RBI::Attr
          scope = node.parent_scope
          scope_name = scope_name(scope)
          allow_missing = annotations.include?("method_missing")

          node.names.each do |name|
            @context.add_method(scope_name, name.to_s, loc, allow_missing: allow_missing)
            if node.is_a?(RBI::AttrWriter) || node.is_a?(RBI::AttrAccessor)
              @context.add_method(scope_name, "#{name}=", loc, allow_missing: allow_missing)
            end
          end
        end
      end

      sig { params(node: RBI::Node).returns(T::Array[String]) }
      def validate_annotations!(node)
        annotations = []

        return annotations unless node.is_a?(RBI::NodeWithComments)

        node.comments.each do |comment|
          text = comment.text
          matches = /^@(?<tag>[a-z_]+)(: ?(?<desc>.*))?$/.match(text)

          next unless matches

          tag = matches[:tag]
          next unless tag

          case tag
          when "method_missing", "shim"
            unless matches[:desc]
              error("Annotation `@#{tag}` requires a description (#{comment.loc})")
            end
          end

          annotations << tag
        end

        annotations
      end

      sig { params(scope: T.nilable(RBI::Scope)).returns(String) }
      def scope_name(scope)
        scope_name = case scope
        when RBI::Class, RBI::Module
          scope.fully_qualified_name
        when RBI::SingletonClass
          scope.parent_scope&.fully_qualified_name
        end

        scope_name || "Object"
      end
    end
  end
end
