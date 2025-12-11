# typed: true

module T::Props::Serializable::ClassMethods
  extend T::Generic

  has_attached_class!(:out) { { upper: T::Struct } }

  sig { params(hash: T::Hash[String, T.untyped]).returns(T.attached_class) }
  def from_hash!(hash); end

  sig { params(hash: T::Hash[String, T.untyped], strict: T::Boolean).returns(T.attached_class) }
  def from_hash(hash, strict = false); end
end
