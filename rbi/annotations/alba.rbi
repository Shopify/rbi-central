# typed: true

module Alba::Resource::ClassMethods
  sig do
    params(
      name: T.any(String, Symbol),
      condition: T.nilable(Proc),
      resource: T.nilable(T.any(Module, String, Proc)),
      serializer: T.nilable(T.any(Module, String, Proc)),
      source: T.nilable(Proc),
      key: T.nilable(T.any(String, Symbol)),
      with_traits: T.nilable(T.any(Symbol, T::Array[Symbol])),
      params: T::Hash[T.untyped, T.untyped],
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.untyped).void),
    ).void
  end
  def association(name, condition = nil, resource: nil, serializer: nil, source: nil, key: nil, with_traits: nil, params: T.unsafe(nil), **options, &block); end

  sig do
    params(
      name: T.nilable(T.any(String, Symbol)),
      if: T.nilable(T.any(Symbol, Proc)),
      name_with_type: T.untyped,
      block: T.proc.bind(T.untyped).params(object: T.untyped).returns(T.untyped),
    ).void
  end
  def attribute(name = nil, if: nil, **name_with_type, &block); end

  sig do
    params(
      attrs: T.any(String, Symbol),
      if: T.nilable(T.any(Symbol, Proc)),
      attrs_with_types: T.untyped,
    ).void
  end
  def attributes(*attrs, if: nil, **attrs_with_types); end

  sig { params(key: T.any(String, Symbol)).void }
  def collection_key(key); end

  sig do
    params(
      name: T.any(String, Symbol),
      condition: T.nilable(Proc),
      resource: T.nilable(T.any(Module, String, Proc)),
      serializer: T.nilable(T.any(Module, String, Proc)),
      source: T.nilable(Proc),
      key: T.nilable(T.any(String, Symbol)),
      with_traits: T.nilable(T.any(Symbol, T::Array[Symbol])),
      params: T::Hash[T.untyped, T.untyped],
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.untyped).void),
    ).void
  end
  def has_many(name, condition = nil, resource: nil, serializer: nil, source: nil, key: nil, with_traits: nil, params: T.unsafe(nil), **options, &block); end

  sig do
    params(
      name: T.any(String, Symbol),
      condition: T.nilable(Proc),
      resource: T.nilable(T.any(Module, String, Proc)),
      serializer: T.nilable(T.any(Module, String, Proc)),
      source: T.nilable(Proc),
      key: T.nilable(T.any(String, Symbol)),
      with_traits: T.nilable(T.any(Symbol, T::Array[Symbol])),
      params: T::Hash[T.untyped, T.untyped],
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.untyped).void),
    ).void
  end
  def has_one(name, condition = nil, resource: nil, serializer: nil, source: nil, key: nil, with_traits: nil, params: T.unsafe(nil), **options, &block); end

  sig { params(mod: Module, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def helper(mod = T.unsafe(nil), &block); end

  sig { params(file: T.nilable(String), inline: T.nilable(Proc)).void }
  def layout(file: nil, inline: nil); end

  sig do
    params(
      name: T.any(String, Symbol),
      condition: T.nilable(Proc),
      resource: T.nilable(T.any(Module, String, Proc)),
      serializer: T.nilable(T.any(Module, String, Proc)),
      source: T.nilable(Proc),
      key: T.nilable(T.any(String, Symbol)),
      with_traits: T.nilable(T.any(Symbol, T::Array[Symbol])),
      params: T::Hash[T.untyped, T.untyped],
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.untyped).void),
    ).void
  end
  def many(name, condition = nil, resource: nil, serializer: nil, source: nil, key: nil, with_traits: nil, params: T.unsafe(nil), **options, &block); end

  sig do
    params(
      key: T.nilable(T.any(String, Symbol)),
      block: T.nilable(T.proc.bind(T.untyped).returns(T::Hash[T.untyped, T.untyped])),
    ).void
  end
  def meta(key = :meta, &block); end

  sig do
    params(
      name: T.any(String, Symbol),
      options: T.untyped,
      block: T.proc.bind(T.untyped).void,
    ).void
  end
  def nested(name, **options, &block); end

  sig do
    params(
      name: T.any(String, Symbol),
      options: T.untyped,
      block: T.proc.bind(T.untyped).void,
    ).void
  end
  def nested_attribute(name, **options, &block); end

  sig do
    params(
      handler: T.nilable(Symbol),
      block: T.nilable(T.proc.params(error: T.untyped, object: T.untyped, key: T.untyped, attribute: T.untyped, resource_class: T.untyped).returns(T::Array[T.untyped])),
    ).void
  end
  def on_error(handler = nil, &block); end

  sig do
    params(
      block: T.nilable(T.proc.bind(T.untyped).params(object: T.untyped, key: T.untyped, attribute: T.untyped).returns(T.untyped)),
    ).void
  end
  def on_nil(&block); end

  sig do
    params(
      name: T.any(String, Symbol),
      condition: T.nilable(Proc),
      resource: T.nilable(T.any(Module, String, Proc)),
      serializer: T.nilable(T.any(Module, String, Proc)),
      source: T.nilable(Proc),
      key: T.nilable(T.any(String, Symbol)),
      with_traits: T.nilable(T.any(Symbol, T::Array[Symbol])),
      params: T::Hash[T.untyped, T.untyped],
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.untyped).void),
    ).void
  end
  def one(name, condition = nil, resource: nil, serializer: nil, source: nil, key: nil, with_traits: nil, params: T.unsafe(nil), **options, &block); end

  sig { void }
  def prefer_object_method!; end

  sig { void }
  def prefer_resource_method!; end

  sig { params(key: T.any(String, Symbol), key_for_collection: T.nilable(T.any(String, Symbol))).void }
  def root_key(key, key_for_collection = nil); end

  sig { void }
  def root_key!; end

  sig { params(key: T.any(String, Symbol)).void }
  def root_key_for_collection(key); end

  sig { params(name: T.any(String, Symbol), block: T.proc.bind(T.untyped).void).void }
  def trait(name, &block); end

  sig { params(type: T.any(String, Symbol), root: T::Boolean, cascade: T::Boolean).void }
  def transform_keys(type, root: true, cascade: true); end
end
