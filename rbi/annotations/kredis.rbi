# typed: true

module Kredis::Types
  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def boolean(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, expires_in: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Counter) }
  def counter(key, expires_in: nil, default: nil, config: nil, after_change: nil); end

  sig { params(key: T.untyped, values: T.untyped, expires_in: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Cycle) }
  def cycle(key, values:, expires_in: nil, config: nil, after_change: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def datetime(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def decimal(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Flag) }
  def flag(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def float(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, typed: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Hash) }
  def hash(key, typed: nil, default: nil, config: nil, after_change: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def integer(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def json(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, typed: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::List) }
  def list(key, default: nil, typed: nil, config: nil, after_change: nil); end

  sig { params(key: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Proxy) }
  def proxy(key, config: nil, after_change: nil); end

  sig { params(key: T.untyped, typed: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def scalar(key, typed: nil, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, typed: T.untyped, config: T.untyped, after_change: T.untyped,).returns(Kredis::Types::Set) }
  def set(key, default: nil, typed: nil, config: nil, after_change: nil); end

  sig { params(key: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Slots) }
  def slot(key, config: nil, after_change: nil); end

  sig { params(key: T.untyped, available: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::Slots) }
  def slots(key, available:, config: nil, after_change: nil); end

  sig { params(key: T.untyped, default: T.untyped, config: T.untyped, after_change: T.untyped, expires_in: T.untyped).returns(Kredis::Types::Scalar) }
  def string(key, default: nil, config: nil, after_change: nil, expires_in: nil); end

  sig { params(key: T.untyped, default: T.untyped, typed: T.untyped, limit: T.untyped, config: T.untyped, after_change: T.untyped).returns(Kredis::Types::UniqueList) }
  def unique_list(key, default: nil, typed: nil, limit: nil, config: nil, after_change: nil); end
end

class Kredis::Types::Counter
  sig { params(by: Integer).returns(Integer) }
  def increment(by: 1); end

  sig { params(by: Integer).returns(Integer) }
  def decrement(by: 1); end

  sig { returns(Integer) }
  def value; end
end

class Kredis::Types::Flag
  sig { returns(T::Boolean) }
  def marked?; end
end

class Kredis::Types::Hash
  sig { returns(ActiveSupport::HashWithIndifferentAccess) }
  def entries; end

  sig { returns(T::Array[String]) }
  def keys; end

  sig { returns(T::Array[T.untyped]) }
  def values; end

  sig { params(keys: T.untyped).returns(T::Array[T.untyped]) }
  def values_at(*keys); end
end

class Kredis::Types::List
  sig { returns(T::Array[T.untyped]) }
  def elements; end
end

class Kredis::Types::Proxy
  # @method_missing: subclasses delegate (via `proxying` class method) to Proxy, https://github.com/rails/kredis/blob/v1.3.0/lib/kredis/types/proxy.rb#L23
  sig { params(_arg0: T.untyped, _arg1: T.untyped, _arg2: T.nilable(T.proc.void)).returns(T::Boolean) }
  def exists?(*_arg0, **_arg1, &_arg2); end
end

class Kredis::Types::Scalar
  sig { returns(T::Boolean) }
  def assigned?; end
end

class Kredis::Types::Set
  sig { returns(T::Array[T.untyped]) }
  def members; end

  sig { params(member: T.untyped).returns(T::Boolean) }
  def include?(member); end

  sig { returns(Integer) }
  def size; end
end

class Kredis::Types::Slots
  sig { params(block: T.nilable(T.proc.returns(T::Boolean))).returns(T::Boolean) }
  def reserve(&block); end

  sig { returns(T::Boolean) }
  def release; end

  sig { returns(T::Boolean) }
  def available?; end

  sig { returns(Integer) }
  def taken; end
end

class Kredis::Types::UniqueList
  sig { returns(T::Array[T.untyped]) }
  def elements; end
end
