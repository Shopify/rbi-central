# typed: strict

module TypeCoerce
  Elem = type_member

  # @shim: at runtime, this is delegated to TypeCoerce::Converter; the use-case looks like: TypeCoerce[Klass].new.from(...)
  sig { params(args: T.untyped, raise_coercion_error: T.nilable(T::Boolean), coerce_empty_to_nil: T::Boolean).returns(Elem) }
  def from(args, raise_coercion_error: nil, coerce_empty_to_nil: false); end
end
