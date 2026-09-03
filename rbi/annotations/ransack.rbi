# typed: true

class Ransack::Search
  sig { params(opts: T::Hash[T.untyped, T.untyped]).returns(ActiveRecord::Relation) }
  def result(opts = {}); end
end

module Ransack::Adapters::ActiveRecord::Base
  sig { overridable.params(auth_object: T.untyped).returns(T::Array[String]) }
  def ransackable_associations(auth_object = nil); end

  sig { overridable.params(auth_object: T.untyped).returns(T::Array[String]) }
  def ransackable_attributes(auth_object = nil); end

  sig { overridable.params(auth_object: T.untyped).returns(T::Array[Symbol]) }
  def ransackable_scopes(auth_object = nil); end

  sig { overridable.params(auth_object: T.untyped).returns(T::Array[String]) }
  def ransortable_attributes(auth_object = nil); end
end
