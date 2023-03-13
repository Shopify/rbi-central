# typed: strong

class Money
  sig { returns(BigDecimal) }
  attr_reader :value

  sig { returns(T.any(Money::Currency, Money::NullCurrency)) }
  attr_reader :currency

  sig do
    params(
      value: T.nilable(T.any(Money, Numeric, String)),
      currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String)),
    )
      .void
  end
  def initialize(value, currency); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(T::Boolean) }
  def zero?(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(T::Boolean) }
  def nonzero?(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(T::Boolean) }
  def positive?(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(T::Boolean) }
  def negative?(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(Integer) }
  def to_i(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(Float) }
  def to_f(*args, **_arg1, &block); end

  # @method_missing: delegated to BigDecimal
  sig { params(args: T.untyped, _arg1: T.untyped, block: T.nilable(T.proc.void)).returns(Integer) }
  def hash(*args, **_arg1, &block); end

  class << self
    sig { params(block: T.nilable(T.proc.params(config: Money::Config).void)).void }
    def configure(&block); end

    sig do
      params(
        value: T.nilable(T.any(Money, Numeric, String)),
        currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String)),
      )
        .returns(Money)
    end
    def new(value = 0, currency = nil); end

    sig do
      params(
        subunits: T.nilable(T.any(Money, Numeric, String)),
        currency_iso: T.nilable(T.any(Money::Currency, Money::NullCurrency, String)),
        format: Symbol,
      )
        .returns(Money)
    end
    def from_subunits(subunits, currency_iso, format: :iso4217); end

    sig { params(money1: Money, money2: Money).returns(Rational) }
    def rational(money1, money2); end

    sig { returns(T.nilable(T.any(Money::Currency, Money::NullCurrency, String))) }
    def current_currency; end

    sig { params(currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String))).void }
    def current_currency=(currency); end

    sig do
      type_parameters(:U)
        .params(
          new_currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String)),
          block: T.nilable(T.proc.returns(T.type_parameter(:U))),
        )
        .returns(T.type_parameter(:U))
    end
    def with_currency(new_currency, &block); end
  end

  sig { params(format: Symbol).returns(Integer) }
  def subunits(format: :iso4217); end

  sig { returns(T::Boolean) }
  def no_currency?; end

  sig { returns(Money) }
  def -@; end

  sig { params(other: T.untyped).returns(T.nilable(Integer)) }
  def <=>(other); end

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

  sig { params(currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String))).returns(Money) }
  def to_money(currency = nil); end

  sig { returns(BigDecimal) }
  def to_d; end

  sig { params(style: T.nilable(Symbol)).returns(String) }
  def to_fs(style = nil); end

  sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).returns(String) }
  def to_json(options = nil); end

  sig { params(options: T.nilable(T::Hash[Symbol, T.untyped])).returns(T::Hash[Symbol, String]) }
  def as_json(options = nil); end

  sig { returns(Money) }
  def abs; end

  sig { returns(Money) }
  def floor; end

  sig { params(ndigits: Integer).returns(Money) }
  def round(ndigits = 0); end

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

class Numeric
  sig { params(currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String))).returns(Money) }
  def to_money(currency = nil); end
end

class String
  sig { params(currency: T.nilable(T.any(Money::Currency, Money::NullCurrency, String))).returns(Money) }
  def to_money(currency = nil); end
end
