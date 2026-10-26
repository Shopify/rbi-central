# typed: true

module Discard::Model::ClassMethods
  has_attached_class!(:out)

  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def before_discard(*args, **options, &block); end

  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class, block: T.proc.void).void)
    ).void
  end
  def around_discard(*args, **options, &block); end

  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def after_discard(*args, **options, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def before_undiscard(*args, **options, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class, block: T.proc.void).void)
    ).void
  end
  def around_undiscard(*args, **options, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig do
    params(
      args: T.untyped,
      options: T.untyped,
      block: T.nilable(T.proc.bind(T.attached_class).params(record: T.attached_class).void)
    ).void
  end
  def after_undiscard(*args, **options, &block); end
end
