# typed: strict

module ActiveSupport
  sig { params(kind: Symbol, blk: T.proc.bind(T.untyped).void).void }
  def self.on_load(kind, &blk); end
end

module ActiveSupport::Testing::Declarative
  sig { params(name: String, block: T.proc.bind(T.untyped).void).void }
  def test(name, &block); end
end

class ActiveSupport::EnvironmentInquirer
  sig { returns(T::Boolean) }
  def development?; end

  sig { returns(T::Boolean) }
  def production?; end

  sig { returns(T::Boolean) }
  def test?; end

  # @method_missing: delegated to String through ActiveSupport::StringInquirer
  sig { returns(T::Boolean) }
  def staging?; end
end

module ActiveSupport::Testing::SetupAndTeardown::ClassMethods
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def setup(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.untyped).void)).void }
  def teardown(*args, &block); end
end

class ActiveSupport::TestCase
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.attached_class).void)).void }
  def self.setup(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(T.attached_class).void)).void }
  def self.teardown(*args, &block); end

  sig { params(name: String, block: T.proc.bind(T.attached_class).void).void }
  def self.test(name, &block); end
end

class String
  sig { returns(T::Boolean) }
  def blank?; end
end
