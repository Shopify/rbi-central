# typed: strong

class Money
  sig { params(other: T.untyped).returns(Money) }
  def +(other); end

  sig { params(other: T.untyped).returns(Money) }
  def -(other); end

  sig { params(numeric: Numeric).returns(Money) }
  def *(numeric); end

  sig { params(numeric: Numeric).returns(T.noreturn) }
  def /(numeric); end

  sig { returns(String) }
  def inspect; end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def ==(other); end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def eql?(other); end

  sig { returns(Money) }
  def abs; end

  sig { returns(Money) }
  def floor; end

  sig { params(ndigits: Integer).returns(Money) }
  def round(ndigits); end

  sig { params(rate: Numeric).returns(Money) }
  def fraction(rate); end

  sig { params(splits: T::Array[Numeric], strategy: Symbol).returns(T::Array[Money]) }
  def allocate(splits, strategy); end

  sig { params(maximums: T::Array[Numeric]).returns(T::Array[Money]) }
  def allocate_max_amounts(maximums); end

  sig { params(num: Numeric).returns(T::Array[Money]) }
  def split(num); end

  sig { params(num: Numeric).returns(T::Hash[Money, Numeric]) }
  def calculate_splits(num); end

  sig { params(min: Numeric, max: Numeric).returns(Money) }
  def clamp(min, max); end
end
