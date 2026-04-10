# typed: true

module Discard::Model::ClassMethods
  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def before_discard(*args, &block); end

  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def around_discard(*args, &block); end

  # @shim: defined dynamically via `define_model_callbacks :discard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def after_discard(*args, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def before_undiscard(*args, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def around_undiscard(*args, &block); end

  # @shim: defined dynamically via `define_model_callbacks :undiscard`
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def after_undiscard(*args, &block); end
end
