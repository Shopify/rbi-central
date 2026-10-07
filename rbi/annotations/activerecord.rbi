# typed: true

class ActiveRecord::Schema
  sig { params(info: T::Hash[T.untyped, T.untyped], blk: T.proc.bind(ActiveRecord::Schema).void).void }
  def self.define(info = nil, &blk); end
end

class ActiveRecord::Migration
  # @shim: Methods on migration are delegated to `SchemaStatements` using `method_missing`
  include ActiveRecord::ConnectionAdapters::SchemaStatements
  # @shim: Methods on migration are delegated to `DatabaseStatements` using `method_missing`
  include ActiveRecord::ConnectionAdapters::DatabaseStatements
end

module ActiveRecord::ConnectionHandling
  # @version >= 7.0.0
  sig do
    type_parameters(:R)
      .params(
        role: T.nilable(Symbol),
        shard: T.nilable(Symbol),
        prevent_writes: T::Boolean,
        blk: T.proc.returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  def connected_to(role: nil, shard: nil, prevent_writes: false, &blk); end

  # @version >= 7.0.0
  sig do
    type_parameters(:R)
      .params(
        classes: T.any(T.class_of(ActiveRecord::Base), T::Array[T.class_of(ActiveRecord::Base)]),
        role: Symbol,
        shard: T.nilable(Symbol),
        prevent_writes: T::Boolean,
        blk: T.proc.returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  def connected_to_many(*classes, role:, shard: nil, prevent_writes: false, &blk); end

  # @version >= 8.0.0
  sig do
    type_parameters(:R)
      .params(
        role: T.nilable(Symbol),
        prevent_writes: T::Boolean,
        blk: T.proc.returns(T.type_parameter(:R)),
      )
      .returns(T::Array[T.type_parameter(:R)])
  end
  def connected_to_all_shards(role: nil, prevent_writes: false, &blk); end

  # @version >= 7.0.0
  sig do
    type_parameters(:R)
      .params(
        enabled: T::Boolean,
        block: T.proc.returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  def prohibit_shard_swapping(enabled = true, &block); end

  # @version >= 7.0.0
  sig do
    type_parameters(:R)
      .params(
        enabled: T::Boolean,
        block: T.proc.returns(T.type_parameter(:R)),
      )
      .returns(T.type_parameter(:R))
  end
  def while_preventing_writes(enabled = true, &block); end
end

class ActiveRecord::Base
  sig { returns(FalseClass) }
  def blank?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  sig { returns(TrueClass) }
  def present?; end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_initialize(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_find(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_touch(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.before_validation(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_validation(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.before_save(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.around_save(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_save(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.before_create(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.around_create(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_create(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.before_update(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.around_update(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_update(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.before_destroy(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.around_destroy(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_destroy(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_commit(*args, **options, &block); end

  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def self.after_rollback(*args, **options, &block); end
end

class ActiveRecord::Relation
  Elem = type_member(:out) { { fixed: T.untyped } }

  sig { returns(T::Boolean) }
  def blank?; end

  sig { abstract.params(blk: T.proc.params(arg0: Elem).returns(BasicObject)).returns(T.untyped) }
  sig { abstract.returns(T::Enumerator[Elem]) }
  def each(&blk); end
end

module ActiveRecord::Core
  sig { params(comparison_object: T.anything).returns(T::Boolean) }
  def ==(comparison_object); end
end
