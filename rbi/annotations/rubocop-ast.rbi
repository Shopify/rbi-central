# typed: true

module RuboCop
  module AST
    class Node < ::Parser::AST::Node
      # Requires https://github.com/sorbet/sorbet/pull/8854
      sig { returns(T::Boolean).narrows_to(RuboCop::AST::ConstNode) }
      def const_type?; end

      sig { returns(T::Boolean).narrows_to(RuboCop::AST::SendNode) }
      def send_type?; end
    end

    module ParameterizedNode
      sig { returns(T::Boolean) }
      def parenthesized?; end

      sig { returns(T.nilable(RuboCop::AST::Node)) }
      def first_argument; end

      sig { returns(T.nilable(RuboCop::AST::Node)) }
      def last_argument; end

      sig { returns(T::Boolean) }
      def arguments?; end

      sig { returns(T::Boolean) }
      def splat_argument?; end

      sig { returns(T::Boolean) }
      def rest_argument?; end

      sig { returns(T::Boolean) }
      def block_argument?; end

      module RestArguments
        include ParameterizedNode

        sig { returns(T::Array[RuboCop::AST::Node]) }
        def arguments; end

        sig { returns(T.nilable(RuboCop::AST::Node)) }
        def first_argument; end

        sig { returns(T.nilable(RuboCop::AST::Node)) }
        def last_argument; end

        sig { returns(T::Boolean) }
        def arguments?; end
      end
    end

    module MethodDispatchNode
      sig { returns(T.nilable(RuboCop::AST::Node)) }
      def receiver; end

      sig { returns(T.nilable(RuboCop::AST::Node)) }
      def method_name; end

      sig { returns(::Parser::Source::Range) }
      def selector; end

      sig { returns(T.nilable(RuboCop::AST::BlockNode)) }
      def block_node; end

      sig { returns(T::Boolean) }
      def macro?; end

      sig { returns(T::Boolean) }
      def access_modifier?; end

      sig { returns(T::Boolean) }
      def bare_access_modifier?; end

      sig { returns(T::Boolean) }
      def non_bare_access_modifier?; end

      sig { returns(T::Boolean) }
      def special_modifier?; end

      sig { params(name: T.any(Symbol, String)).returns(T::Boolean) }
      def command?(name); end

      sig { returns(T::Boolean) }
      def setter_method?; end

      sig { returns(T::Boolean) }
      def assignment?; end

      sig { returns(T::Boolean) }
      def dot?; end

      sig { returns(T::Boolean) }
      def double_colon?; end

      sig { returns(T::Boolean) }
      def safe_navigation?; end

      sig { returns(T::Boolean) }
      def self_receiver?; end

      sig { returns(T::Boolean) }
      def const_receiver?; end

      sig { returns(T::Boolean) }
      def implicit_call?; end

      sig { returns(T::Boolean) }
      def block_literal?; end

      sig { returns(T::Boolean) }
      def arithmetic_operation?; end

      sig { params(node: T.nilable(RuboCop::AST::Node)).returns(T::Boolean) }
      def def_modifier?(node = T.unsafe(nil)); end

      sig { params(node: T.nilable(RuboCop::AST::Node)).returns(T.nilable(RuboCop::AST::Node)) }
      def def_modifier(node = T.unsafe(nil)); end

      sig { returns(T::Boolean) }
      def lambda?; end

      sig { returns(T::Boolean) }
      def lambda_literal?; end

      sig { returns(T::Boolean) }
      def unary_operation?; end

      sig { returns(T::Boolean) }
      def binary_operation?; end
    end

    module ConstantNode
      sig { returns(T.nilable(RuboCop::AST::Node)) }
      def namespace; end

      sig { returns(Symbol) }
      def short_name; end

      sig { returns(T::Boolean) }
      def module_name?; end

      sig { returns(T::Boolean) }
      def class_name?; end

      sig { returns(T::Boolean) }
      def absolute?; end

      sig { returns(T::Boolean) }
      def relative?; end

      sig { returns(T::Enumerator[RuboCop::AST::Node]) }
      sig { params(block: T.proc.params(node: RuboCop::AST::Node).void).returns(T.self_type) }
      def each_path(&block); end
    end

    class ConstNode < RuboCop::AST::Node
      include ConstantNode

      sig { override.returns(TrueClass).narrows_to(RuboCop::AST::ConstNode) }
      def const_type?; end
    end

    class SendNode < Node
      include ParameterizedNode::RestArguments
      include MethodDispatchNode

      sig {override.returns(TrueClass).narrows_to(RuboCop::AST::SendNode) }
      def send_type; end
    end
  end
end
