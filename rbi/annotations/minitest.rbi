# typed: true

module Minitest::Assertions
  sig { params(test: T.untyped, msg: T.nilable(String)).void }
  def assert(test, msg = T.unsafe(nil)); end

  sig { params(obj: T.untyped, msg: T.nilable(String)).void }
  def assert_empty(obj, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, msg: T.nilable(String)).void }
  def assert_equal(exp, act, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, delta: T.untyped, msg: T.nilable(String)).void }
  def assert_in_delta(exp, act, delta = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, epsilon: T.untyped, msg: T.nilable(String)).void }
  def assert_in_epsilon(exp, act, epsilon = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(collection: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def assert_includes(collection, obj, msg = T.unsafe(nil)); end

  sig { params(cls: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def assert_instance_of(cls, obj, msg = T.unsafe(nil)); end

  sig { params(cls: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def assert_kind_of(cls, obj, msg = T.unsafe(nil)); end

  sig { params(matcher: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def assert_match(matcher, obj, msg = T.unsafe(nil)); end

  sig { params(mock: T.untyped).void }
  def assert_mock(mock); end

  sig { params(obj: T.untyped, msg: T.nilable(String)).void }
  def assert_nil(obj, msg = T.unsafe(nil)); end

  sig { params(o1: T.untyped, op: T.untyped, o2: T.untyped, msg: T.nilable(String)).void }
  def assert_operator(o1, op, o2 = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(stdout: T.untyped, stderr: T.untyped).void }
  def assert_output(stdout = T.unsafe(nil), stderr = T.unsafe(nil)); end

  sig { params(path: T.untyped, msg: T.nilable(String)).void }
  def assert_path_exists(path, msg = T.unsafe(nil)); end

  sig { params(o1: T.untyped, op: T.untyped, msg: T.nilable(String)).void }
  def assert_predicate(o1, op, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, block: T.proc.void).returns(T.untyped) }
  def assert_raises(*exp, &block); end

  sig { params(obj: T.untyped, meth: T.untyped, msg: T.nilable(String)).void }
  def assert_respond_to(obj, meth, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, msg: T.nilable(String)).void }
  def assert_same(exp, act, msg = T.unsafe(nil)); end

  sig { params(send_ary: T.untyped, m: T.nilable(String)).void }
  def assert_send(send_ary, m = T.unsafe(nil)); end

  sig { params(block: T.proc.void).void }
  def assert_silent(&block); end

  sig { params(sym: T.untyped, msg: T.nilable(String)).void }
  def assert_throws(sym, msg = T.unsafe(nil)); end

  sig { params(test: T.untyped, msg: T.nilable(String)).void }
  def refute(test, msg = T.unsafe(nil)); end

  sig { params(obj: T.untyped, msg: T.nilable(String)).void }
  def refute_empty(obj, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, msg: T.nilable(String)).void }
  def refute_equal(exp, act, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, delta: T.untyped, msg: T.nilable(String)).void }
  def refute_in_delta(exp, act, delta = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(a: T.untyped, b: T.untyped, epsilon: T.untyped, msg: T.nilable(String)).void }
  def refute_in_epsilon(a, b, epsilon = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(collection: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def refute_includes(collection, obj, msg = T.unsafe(nil)); end

  sig { params(cls: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def refute_instance_of(cls, obj, msg = T.unsafe(nil)); end

  sig { params(cls: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def refute_kind_of(cls, obj, msg = T.unsafe(nil)); end

  sig { params(matcher: T.untyped, obj: T.untyped, msg: T.nilable(String)).void }
  def refute_match(matcher, obj, msg = T.unsafe(nil)); end

  sig { params(obj: T.untyped, msg: T.nilable(String)).void }
  def refute_nil(obj, msg = T.unsafe(nil)); end

  sig { params(o1: T.untyped, op: T.untyped, o2: T.untyped, msg: T.nilable(String)).void }
  def refute_operator(o1, op, o2 = T.unsafe(nil), msg = T.unsafe(nil)); end

  sig { params(path: T.untyped, msg: T.nilable(String)).void }
  def refute_path_exists(path, msg = T.unsafe(nil)); end

  sig { params(o1: T.untyped, op: T.untyped, msg: T.nilable(String)).void }
  def refute_predicate(o1, op, msg = T.unsafe(nil)); end

  sig { params(obj: T.untyped, meth: T.untyped, msg: T.nilable(String)).void }
  def refute_respond_to(obj, meth, msg = T.unsafe(nil)); end

  sig { params(exp: T.untyped, act: T.untyped, msg: T.nilable(String)).void }
  def refute_same(exp, act, msg = T.unsafe(nil)); end
end
