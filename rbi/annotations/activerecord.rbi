# typed: strict

class ActiveRecord::Schema
  sig {params(info: T::Hash[T.untyped, T.untyped], blk: T.proc.bind(ActiveRecord::Schema).void).void}
  def self.define(info = nil, &blk); end
end

class ActiveRecord::Migration
  # @shim: Methods on migration are delegated to `SchemaStatements` using `method_missing`
  include ActiveRecord::ConnectionAdapters::SchemaStatements
  # @shim: Methods on migration are delegated to `DatabaseaStatements` using `method_missing`
  include ActiveRecord::ConnectionAdapters::DatabaseStatements
end

class ActiveRecord::Base
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
