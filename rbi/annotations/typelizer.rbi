# typed: true

module Typelizer
  class WriterContext
    sig { params(serializer_class: T::Module[T.anything]).returns(Typelizer::Interface) }
    def interface_for(serializer_class); end
  end

  class Interface
    # An inline interface is an anonymous serializer rendered in place rather than by reference.
    sig { returns(T::Boolean) }
    def inline?; end

    sig { returns(String) }
    def name; end

    sig { returns(T::Array[Typelizer::Property]) }
    def properties; end

    sig { returns(T::Array[Typelizer::Interface]) }
    def trait_interfaces; end
  end

  class Shape
    sig { returns(T::Array[Typelizer::Property]) }
    def properties; end
  end

  module OpenAPI
    class << self
      # The schema is plain JSON Schema: nested hashes and arrays of arbitrary depth.
      sig do
        params(
          interface: T.any(Typelizer::Interface, Typelizer::Shape),
          openapi_version: String,
        ).returns(T::Hash[Symbol, T.untyped])
      end
      def schema_for(interface, openapi_version: "3.0"); end
    end
  end
end
