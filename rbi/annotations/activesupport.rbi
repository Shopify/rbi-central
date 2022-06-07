# typed: strict

class ActiveSupport::TestCase
  sig { params(args: T.untyped, block: T.proc.bind(T.attached_class).void).void }
  def self.setup(*args, &block); end

  sig { params(args: T.untyped, block: T.proc.bind(T.attached_class).void).void }
  def self.teardown(*args, &block); end

  sig { params(name: String, block: T.proc.bind(T.attached_class).void).void }
  def self.test(name, &block); end
end

class String
  sig { returns(T::Boolean) }
  def blank?; end
end
