# typed: true

module Dry::Monads
  class << self
    sig do
      type_parameters(:U)
        .params(value: T.nilable(T.type_parameter(:U)))
        .returns(Dry::Monads::Maybe[T.type_parameter(:U)])
    end
    def Maybe(value)
    end
  end
end

class Dry::Monads::Maybe
  Elem = type_member(:out)

  sig { returns(Elem) }
  def value!
  end

  sig do
    type_parameters(:U)
      .params(
        _arg0: T.anything,
        _arg1: T.anything,
        _arg2: T.proc.params(arg0: Elem).returns(Dry::Monads::Maybe[T.type_parameter(:U)])
      )
      .returns(Dry::Monads::Maybe[T.type_parameter(:U)])
  end
  def bind(*_arg0, **_arg1, &_arg2)
  end

  sig do
    type_parameters(:U)
      .params(blk: T.proc.returns(T.type_parameter(:U)))
      .returns(T.any(Dry::Monads::Maybe[Elem], T.type_parameter(:U)))
  end
  def or(&blk)
  end

  sig do
    type_parameters(:U)
      .params(
        _arg0: T.anything,
        _arg1: T.anything,
        _arg2: T.proc.params(arg0: Elem).returns(T.type_parameter(:U))
      )
      .returns(Dry::Monads::Maybe[T.type_parameter(:U)])
  end
  def fmap(*_arg0, **_arg1, &_arg2)
  end

  sig do
    type_parameters(:U)
      .params(
        val: T.nilable(T.type_parameter(:U)),
        blk: T.nilable(T.proc.returns(T.type_parameter(:U)))
      )
      .returns(T.any(Elem, T.type_parameter(:U)))
  end
  def value_or(val = nil, &blk)
  end

  sig do
    type_parameters(:U)
      .params(
        _arg0: T.nilable(T.type_parameter(:U)),
        blk: T.nilable(T.proc.returns(T.type_parameter(:U)))
      )
      .returns(Dry::Monads::Result[T.type_parameter(:U), Elem])
  end
  def to_result(_arg0 = nil, &blk)
  end
end

class Dry::Monads::Maybe::None
  Elem = type_member(:out)
end

class Dry::Monads::Maybe::Some
  Elem = type_member(:out)
end

class Dry::Monads::Result
  FailureType = type_member(:out)
  SuccessType = type_member(:out)

  def or(*args)
  end

  sig do
    type_parameters(:U)
      .params(
        _arg0: T.anything,
        _arg1: T.anything,
        _arg2: T.proc.params(arg0: SuccessType).returns(T.type_parameter(:U))
      )
      .returns(Dry::Monads::Result[FailureType, T.type_parameter(:U)])
  end
  def fmap(*_arg0, **_arg1, &_arg2)
  end

  sig { returns(SuccessType) }
  def value!
  end

  sig do
    type_parameters(:U, :V)
      .params(
        _arg0: T.anything,
        _arg1: T.anything,
        _arg2:
          T
            .proc
            .params(arg0: SuccessType)
            .returns(Dry::Monads::Result[T.type_parameter(:U), T.type_parameter(:V)])
      )
      .returns(Dry::Monads::Result[T.any(FailureType, T.type_parameter(:U)), T.type_parameter(:V)])
  end
  def bind(*_arg0, **_arg1, &_arg2)
  end

  sig do
    type_parameters(:U)
      .params(
        val: T.type_parameter(:U),
        blk: T.nilable(T.proc.params(arg0: FailureType).returns(T.type_parameter(:U)))
      )
      .returns(T.any(SuccessType, T.type_parameter(:U)))
  end
  def value_or(val = T.unsafe(nil), &blk)
  end

  sig { returns(T::Boolean) }
  def failure?
  end

  sig { returns(T::Boolean) }
  def success?
  end
end

class Dry::Monads::Result::Failure < ::Dry::Monads::Result
  FailureType = type_member
  SuccessType = type_member
end

class Dry::Monads::Result::Success < ::Dry::Monads::Result
  FailureType = type_member
  SuccessType = type_member
end
