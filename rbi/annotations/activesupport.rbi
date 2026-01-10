# typed: true

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

class ActiveSupport::Duration
  sig { returns(T::Hash[Symbol, Numeric]) }
  def parts; end

  sig { params(other: Numeric).returns(T::Boolean) }
  sig { params(other: ::ActiveSupport::Duration).returns(T::Boolean) }
  def <=>(other); end

  sig { params(other: Numeric).returns(::ActiveSupport::Duration) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::Duration) }
  def +(other); end

  sig { params(other: Numeric).returns(::ActiveSupport::Duration) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::Duration) }
  def -(other); end

  sig { returns(String) }
  def to_s; end

  sig { returns(Integer) }
  def to_i; end

  sig { returns(Integer) }
  def in_seconds; end

  sig { returns(Float) }
  def in_minutes; end

  sig { returns(Float) }
  def in_hours; end

  sig { returns(Float) }
  def in_days; end

  sig { returns(Float) }
  def in_weeks; end

  sig { returns(Float) }
  def in_months; end

  sig { returns(Float) }
  def in_years; end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def eql?(other); end

  sig { returns(Integer) }
  def hash; end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def since(time = ::Time.current); end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def from_now(time = ::Time.current); end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def after(time = ::Time.current); end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def ago(time = ::Time.current); end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def until(time = ::Time.current); end

  sig { params(time: ::ActiveSupport::TimeWithZone).returns(::ActiveSupport::TimeWithZone) }
  def before(time = ::Time.current); end

  sig { returns(String) }
  def inspect; end

  sig { params(options: T.untyped).returns(Integer) }
  def as_json(options = nil); end

  sig { params(precision: T.untyped).returns(String) }
  def iso8601(precision: nil); end

  sig { params(iso8601duration: String).returns(T.attached_class) }
  def self.parse(iso8601duration); end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def self.===(other); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.seconds(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.minutes(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.hours(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.days(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.weeks(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.months(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.years(value); end

  sig { params(value: Numeric).returns(T.attached_class) }
  def self.build(value); end
end

class ActiveSupport::TimeWithZone
  # @shim: Methods on ActiveSupport::TimeWithZone are delegated to `Time` using `method_missing
  include ::DateAndTime::Zones
  # @shim: Methods on ActiveSupport::TimeWithZone are delegated to `Time` using `method_missing
  include ::DateAndTime::Calculations

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  sig { returns(::ActiveSupport::TimeZone) }
  def time_zone; end

  sig { returns(Time) }
  def time; end

  sig { returns(Time) }
  def utc; end

  sig { returns(::TZInfo::TimezonePeriod) }
  def period; end

  sig { returns(Time) }
  def comparable_time; end

  sig { returns(Time) }
  def getgm; end

  sig { returns(Time) }
  def getutc; end

  sig { returns(Time) }
  def gmtime; end

  sig { params(new_zone: ::ActiveSupport::TimeZone).returns(::ActiveSupport::TimeWithZone) }
  def in_time_zone(new_zone = ::Time.zone); end

  sig { returns(T::Boolean) }
  def dst?; end

  sig { returns(T::Boolean) }
  def isdst; end

  sig { returns(T::Boolean) }
  def utc?; end

  sig { returns(T::Boolean) }
  def gmt?; end

  sig { returns(String) }
  def zone; end

  sig { returns(String) }
  def inspect; end

  sig { params(fraction_digits: Integer).returns(String) }
  def xmlschema(fraction_digits = 0); end

  sig { params(fraction_digits: Integer).returns(String) }
  def iso8601(fraction_digits = 0); end

  sig { params(fraction_digits: Integer).returns(String) }
  def rfc3339(fraction_digits = 0); end

  sig { returns(String) }
  def httpdate; end

  sig { returns(String) }
  def rfc2822; end

  sig { returns(String) }
  def rfc822; end

  sig { returns(String) }
  def to_s; end

  sig { params(format: Symbol).returns(String) }
  def to_fs(format = :default); end

  sig { params(format: Symbol).returns(String) }
  def to_formatted_s(format = :default); end

  sig { params(format: String).returns(String) }
  def strftime(format); end

  sig { params(other: T.untyped).returns(Integer) }
  def <=>(other); end

  sig { returns(T::Boolean) }
  def past?; end

  sig { returns(T::Boolean) }
  def today?; end

  sig { returns(T::Boolean) }
  def tomorrow?; end

  sig { returns(T::Boolean) }
  def next_day?; end

  sig { returns(T::Boolean) }
  def yesterday?; end

  sig { returns(T::Boolean) }
  def prev_day?; end

  sig { returns(T::Boolean) }
  def future?; end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def eql?(other); end

  sig { returns(Integer) }
  def hash; end

  sig { params(other: Numeric).returns(::ActiveSupport::TimeWithZone) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::TimeWithZone) }
  def +(other); end

  sig { params(other: Numeric).returns(::ActiveSupport::TimeWithZone) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::TimeWithZone) }
  def since(other); end

  sig { params(other: Numeric).returns(::ActiveSupport::TimeWithZone) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::TimeWithZone) }
  def in(other); end

  sig { params(other: Time).returns(Float) }
  sig { params(other: ::ActiveSupport::TimeWithZone).returns(Float) }
  sig { params(other: Numeric).returns(::ActiveSupport::TimeWithZone) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::TimeWithZone) }
  def -(other); end

  sig { params(other: Numeric).returns(::ActiveSupport::TimeWithZone) }
  sig { params(other: ::ActiveSupport::Duration).returns(::ActiveSupport::TimeWithZone) }
  def ago(other); end

  sig { returns(Integer) }
  def year; end

  sig { returns(Integer) }
  def mon; end

  sig { returns(Integer) }
  def month; end

  sig { returns(Integer) }
  def day; end

  sig { returns(Integer) }
  def mday; end

  sig { returns(Integer) }
  def wday; end

  sig { returns(Integer) }
  def yday; end

  sig { returns(Integer) }
  def hour; end

  sig { returns(Integer) }
  def min; end

  sig { returns(Integer) }
  def sec; end

  sig { returns(Numeric) }
  def usec; end

  sig { returns(Integer) }
  def nsec; end

  sig { returns(Date) }
  def to_date; end

  sig { returns(T::Array[T.untyped]) }
  def to_a; end

  sig { returns(Float) }
  def to_f; end

  sig { returns(Integer) }
  def to_i; end

  sig { returns(Integer) }
  def tv_sec; end

  sig { returns(Rational) }
  def to_r; end

  sig { returns(DateTime) }
  def to_datetime; end

  sig { returns(Time) }
  def to_time; end

  sig { returns(TrueClass) }
  def acts_like_time?; end

  sig { returns(FalseClass) }
  def blank?; end

  sig { returns(TrueClass) }
  def present?; end

  sig { returns(T.self_type) }
  def freeze; end

  # @method_missing: delegated to Time
  sig { returns(T.self_type) }
  def beginning_of_day; end

  # @method_missing: delegated to Time
  sig { returns(T.self_type) }
  def end_of_day; end

  # @method_missing: delegated to Time
  sig { params(days: Integer).returns(T.self_type) }
  def prev_day(days = 1); end

  # @method_missing: delegated to Time
  sig { params(days: Integer).returns(T.self_type) }
  def next_day(days = 1); end

  # @method_missing: delegated to Time
  sig { params(months: Integer).returns(T.self_type) }
  def prev_month(months = 1); end

  # @method_missing: delegated to Time
  sig { params(months: Integer).returns(T.self_type) }
  def next_month(months = 1); end

  # @method_missing: delegated to Time
  sig { params(years: Integer).returns(T.self_type) }
  def prev_year(years = 1); end

  # @method_missing: delegated to Time
  sig { params(years: Integer).returns(T.self_type) }
  def next_year(years = 1); end
end

class ActiveSupport::TimeZone
  sig { returns(::ActiveSupport::TimeWithZone) }
  def now; end

  sig { returns(Date) }
  def today; end

  sig { returns(Date) }
  def tomorrow; end

  sig { returns(Date) }
  def yesterday; end

  sig { params(str: String, now: ::ActiveSupport::TimeWithZone).returns(T.nilable(::ActiveSupport::TimeWithZone)) }
  def parse(str, now = now()); end
end

module DateAndTime::Calculations
  sig { returns(T.self_type) }
  def yesterday; end

  sig { returns(T.self_type) }
  def tomorrow; end

  sig { returns(T.self_type) }
  def beginning_of_month; end

  sig { returns(T.self_type) }
  def at_beginning_of_month; end

  sig { returns(T.self_type) }
  def beginning_of_quarter; end

  sig { returns(T.self_type) }
  def at_beginning_of_quarter; end

  sig { returns(T.self_type) }
  def end_of_quarter; end

  sig { returns(T.self_type) }
  def at_end_of_quarter; end

  sig { returns(T.self_type) }
  def beginning_of_year; end

  sig { returns(T.self_type) }
  def at_beginning_of_year; end

  sig { params(start_day: Symbol).returns(T.self_type) }
  def beginning_of_week(start_day = Date.beginning_of_week); end

  sig { params(start_day: Symbol).returns(T.self_type) }
  def at_beginning_of_week(start_day = Date.beginning_of_week); end

  sig { returns(T.self_type) }
  def end_of_month; end

  sig { returns(T.self_type) }
  def at_end_of_month; end

  sig { returns(T.self_type) }
  def end_of_year; end

  sig { returns(T.self_type) }
  def at_end_of_year; end
end

class Object
  sig { returns(T::Boolean) }
  def blank?; end

  sig { returns(FalseClass) }
  def html_safe?; end

  sig { returns(T.nilable(T.self_type)) }
  def presence; end

  sig { params(another_object: T.untyped).returns(T.nilable(T.self_type)) }
  def presence_in(another_object); end

  sig { returns(T::Boolean) }
  def present?; end
end

class Hash
  sig { returns(T::Boolean) }
  def blank?; end

  sig { returns(T::Boolean) }
  def present?; end

  sig { returns(T::Boolean) }
  def extractable_options?; end

  # @version >= 6.1.0
  sig { returns(T.self_type) }
  def compact_blank; end
end

class Array
  sig { returns(T::Boolean) }
  def blank?; end

  sig { returns(T::Boolean) }
  def present?; end

  sig { params(position: Integer).returns(T.self_type) }
  def from(position); end

  sig { params(position: Integer).returns(T.self_type) }
  def to(position); end

  sig { params(elements: T.untyped).returns(T::Array[T.untyped]) }
  def including(*elements); end

  sig { params(elements: T.untyped).returns(T.self_type) }
  def excluding(*elements); end

  sig { params(elements: T.untyped).returns(T.self_type) }
  def without(*elements); end

  sig { returns(T.nilable(Elem)) }
  def second; end

  sig { returns(T.nilable(Elem)) }
  def third; end

  sig { returns(T.nilable(Elem)) }
  def fourth; end

  sig { returns(T.nilable(Elem)) }
  def fifth; end

  sig { returns(T.nilable(Elem)) }
  def forty_two; end

  sig { returns(T.nilable(Elem)) }
  def third_to_last; end

  sig { returns(T.nilable(Elem)) }
  def second_to_last; end

  sig { params(options: T::Hash[T.untyped, T.untyped]).returns(String) }
  def to_sentence(options = {}); end

  sig { params(format: Symbol).returns(String) }
  def to_fs(format = :default); end

  sig { params(format: Symbol).returns(String) }
  def to_formatted_s(format = :default); end

  sig { returns(String) }
  def to_xml; end

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def extract_options!; end

  sig do
    type_parameters(:FillType)
      .params(
        number: Integer,
        fill_with: T.type_parameter(:FillType),
        block: T.nilable(T.proc.params(group: T::Array[T.any(Elem, T.type_parameter(:FillType))]).void),
      )
      .returns(T::Array[T::Array[T.any(Elem, T.type_parameter(:FillType))]])
  end
  def in_groups(number, fill_with = T.unsafe(nil), &block); end

  sig do
    type_parameters(:FillType)
      .params(
        number: Integer,
        fill_with: T.type_parameter(:FillType),
        block: T.nilable(T.proc.params(group: T::Array[T.any(Elem, T.type_parameter(:FillType))]).void),
      )
      .returns(T::Array[T::Array[T.any(Elem, T.type_parameter(:FillType))]])
  end
  def in_groups_of(number, fill_with = T.unsafe(nil), &block); end

  sig do
    params(value: T.untyped, block: T.nilable(T.proc.params(element: Elem).returns(T.untyped)))
      .returns(T::Array[T::Array[Elem]])
  end
  def split(value = nil, &block); end

  sig do
    params(block: T.nilable(T.proc.params(element: Elem).returns(T.untyped)))
      .returns(T.any(T::Array[Elem], T::Enumerator[Elem]))
  end
  def extract!(&block); end

  sig { returns(ActiveSupport::ArrayInquirer) }
  def inquiry; end

  sig { params(object: T.untyped).returns(T::Array[T.untyped]) }
  def self.wrap(object); end
end

class Date
  sig { returns(FalseClass) }
  def blank?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  # @shim: since `blank?` is always false, `present?` always returns `true`
  sig { returns(TrueClass) }
  def present?; end

  sig { returns(::ActiveSupport::TimeWithZone) }
  def beginning_of_day; end

  sig { returns(::ActiveSupport::TimeWithZone) }
  def at_beginning_of_day; end

  sig { returns(::ActiveSupport::TimeWithZone) }
  def end_of_day; end

  sig { returns(::ActiveSupport::TimeWithZone) }
  def at_end_of_day; end

  sig { params(other: Numeric).returns(T.self_type) }
  sig { params(other: Date).returns(Rational) }
  sig { params(other: DateTime).returns(Rational) }
  sig { params(other: ::ActiveSupport::Duration).returns(T.self_type) }
  def -(other); end

  sig { params(other: Numeric).returns(T.self_type) }
  sig { params(other: Date).returns(Rational) }
  sig { params(other: DateTime).returns(Rational) }
  sig { params(other: ::ActiveSupport::Duration).returns(T.self_type) }
  def +(other); end

  sig { returns(Date) }
  def self.current; end
end

class DateTime
  sig { returns(FalseClass) }
  def blank?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  # @shim: since `blank?` is always false, `present?` always returns `true`
  sig { returns(TrueClass) }
  def present?; end
end

module Enumerable
  sig do
    type_parameters(:Block)
      .params(block: T.proc.params(arg0: Elem).returns(T.type_parameter(:Block)))
      .returns(T::Hash[T.type_parameter(:Block), Elem])
  end
  sig { returns(T::Enumerable[T.untyped]) }
  def index_by(&block); end

  sig do
    type_parameters(:Block)
      .params(block: T.proc.params(arg0: Elem).returns(T.type_parameter(:Block)))
      .returns(T::Hash[Elem, T.type_parameter(:Block)])
  end
  sig { returns(T::Enumerable[T.untyped]) }
  sig do
    type_parameters(:Default)
      .params(default: T.type_parameter(:Default))
      .returns(T::Hash[Elem, T.type_parameter(:Default)])
  end
  def index_with(default = nil, &block); end

  sig { params(block: T.proc.params(arg0: Elem).returns(BasicObject)).returns(T::Boolean) }
  sig { returns(T::Boolean) }
  def many?(&block); end

  sig { params(object: BasicObject).returns(T::Boolean) }
  def exclude?(object); end

  # @version >= 6.1.0
  sig { returns(T::Array[Elem]) }
  def compact_blank; end

  # @version >= 7.0.0
  sig { returns(Elem) }
  def sole; end
end

class NilClass
  sig { returns(TrueClass) }
  def blank?; end

  # @shim: since `present?` is always false, `presence` always returns `nil`
  sig { returns(NilClass) }
  def presence; end

  # @shim: since `blank?` is always true, `present?` always returns `false`
  sig { returns(FalseClass) }
  def present?; end
end

class FalseClass
  sig { returns(TrueClass) }
  def blank?; end

  # @shim: since `present?` is always false, `presence` always returns `nil`
  sig { returns(NilClass) }
  def presence; end

  # @shim: since `blank?` is always true, `present?` always returns `false`
  sig { returns(FalseClass) }
  def present?; end
end

class TrueClass
  sig { returns(FalseClass) }
  def blank?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  # @shim: since `blank?` is always false, `present?` always returns `true`
  sig { returns(TrueClass) }
  def present?; end
end

class Numeric
  sig { returns(FalseClass) }
  def blank?; end

  sig { returns(TrueClass) }
  def html_safe?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  # @shim: since `blank?` is always false, `present?` always returns `true`
  sig { returns(TrueClass) }
  def present?; end

  sig { returns(::ActiveSupport::Duration) }
  def seconds; end

  sig { returns(::ActiveSupport::Duration) }
  def second; end

  sig { returns(::ActiveSupport::Duration) }
  def minutes; end

  sig { returns(::ActiveSupport::Duration) }
  def minute; end

  sig { returns(::ActiveSupport::Duration) }
  def hours; end

  sig { returns(::ActiveSupport::Duration) }
  def hour; end

  sig { returns(::ActiveSupport::Duration) }
  def days; end

  sig { returns(::ActiveSupport::Duration) }
  def day; end

  sig { returns(::ActiveSupport::Duration) }
  def weeks; end

  sig { returns(::ActiveSupport::Duration) }
  def week; end
end

class Float
  sig { params(other: T.any(Integer, Float, Rational, BigDecimal)).returns(T::Boolean) }
  sig { params(other: ::ActiveSupport::Duration).returns(T::Boolean) }
  def <(other); end
end

class Integer
  sig { returns(::ActiveSupport::Duration) }
  def months; end

  sig { returns(::ActiveSupport::Duration) }
  def month; end

  sig { returns(::ActiveSupport::Duration) }
  def years; end

  sig { returns(::ActiveSupport::Duration) }
  def year; end
end

class Time
  sig { returns(FalseClass) }
  def blank?; end

  # @shim: since `present?` is always true, `presence` always returns `self`
  sig { returns(T.self_type) }
  def presence; end

  # @shim: since `blank?` is always false, `present?` always returns `true`
  sig { returns(TrueClass) }
  def present?; end

  sig { params(other: Numeric).returns(Time) }
  sig { params(other: ::ActiveSupport::Duration).returns(Time) }
  def +(other); end

  sig { params(other: Time).returns(Float) }
  sig { params(other: Numeric).returns(Time) }
  sig { params(other: ::ActiveSupport::Duration).returns(Time) }
  def -(other); end

  sig { returns(T.self_type) }
  def beginning_of_day; end

  sig { returns(T.self_type) }
  def end_of_day; end

  sig { params(days: Integer).returns(T.self_type) }
  def prev_day(days = 1); end

  sig { params(days: Integer).returns(T.self_type) }
  def next_day(days = 1); end

  sig { params(months: Integer).returns(T.self_type) }
  def prev_month(months = 1); end

  sig { params(months: Integer).returns(T.self_type) }
  def next_month(months = 1); end

  sig { params(years: Integer).returns(T.self_type) }
  def prev_year(years = 1); end

  sig { params(years: Integer).returns(T.self_type) }
  def next_year(years = 1); end

  sig { returns(::ActiveSupport::TimeWithZone) }
  def self.current; end

  sig { returns(::ActiveSupport::TimeZone) }
  def self.zone; end

  sig { params(month: Integer, year: Integer).returns(Integer) }
  def self.days_in_month(month, year = current.year); end

  sig { params(year: Integer).returns(Integer) }
  def self.days_in_year(year = current.year); end
end

class Symbol
  sig { returns(T::Boolean) }
  def blank?; end

  sig { returns(T::Boolean) }
  def present?; end

  # alias for `#start_with?`
  sig { params(string_or_regexp: T.any(String, Regexp)).returns(T::Boolean) }
  def starts_with?(*string_or_regexp); end

  # alias for `#end_with?`
  sig { params(string_or_regexp: T.any(String, Regexp)).returns(T::Boolean) }
  def ends_with?(*string_or_regexp); end
end

class String
  sig { returns(TrueClass) }
  def acts_like_string?; end

  # This is the subset of `#[]` sigs that have just 1 parameter.
  # https://github.com/sorbet/sorbet/blob/40ad87b4dc7be23fa00c1369ac9f927053c68907/rbi/core/string.rbi#L270-L303
  sig { params(position: Integer).returns(T.nilable(String)) }
  sig { params(position: T.any(T::Range[Integer], Regexp)).returns(T.nilable(String)) }
  sig { params(position: String).returns(T.nilable(String)) }
  def at(position); end

  sig { returns(String) }
  def as_json; end

  sig { returns(T::Boolean) }
  def blank?; end

  sig { params(first_letter: Symbol).returns(String) }
  def camelcase(first_letter = :upper); end

  sig { params(first_letter: Symbol).returns(String) }
  def camelize(first_letter = :upper); end

  sig { returns(String) }
  def classify; end

  sig { returns(T.untyped) }
  def constantize; end

  sig { returns(String) }
  def dasherize; end

  sig { returns(String) }
  def deconstantize; end

  sig { returns(String) }
  def demodulize; end

  # alias for `#end_with?`
  sig { params(string_or_regexp: T.any(String, Regexp)).returns(T::Boolean) }
  def ends_with?(*string_or_regexp); end

  sig { returns(String) }
  def downcase_first; end

  sig { params(string: String).returns(T::Boolean) }
  def exclude?(string); end

  sig { params(limit: Integer).returns(String) }
  def first(limit = 1); end

  sig { params(separate_class_name_and_id_with_underscore: T::Boolean).returns(String) }
  def foreign_key(separate_class_name_and_id_with_underscore = true); end

  sig { params(position: Integer).returns(String) }
  def from(position); end

  sig { returns(ActiveSupport::SafeBuffer) }
  def html_safe; end

  sig { params(capitalize: T::Boolean, keep_id_suffix: T::Boolean).returns(String) }
  def humanize(capitalize: true, keep_id_suffix: false); end

  sig { params(zone: T.nilable(T.any(ActiveSupport::TimeZone, String))).returns(T.any(ActiveSupport::TimeWithZone, Time)) }
  def in_time_zone(zone = ::Time.zone); end

  sig { params(amount: Integer, indent_string: T.nilable(String), indent_empty_lines: T::Boolean).returns(String) }
  def indent(amount, indent_string = nil, indent_empty_lines = false); end

  sig { params(amount: Integer, indent_string: T.nilable(String), indent_empty_lines: T::Boolean).returns(T.nilable(String)) }
  def indent!(amount, indent_string = nil, indent_empty_lines = false); end

  sig { returns(ActiveSupport::StringInquirer) }
  def inquiry; end

  sig { returns(T::Boolean) }
  def is_utf8?; end

  sig { params(limit: Integer).returns(String) }
  def last(limit = 1); end

  sig { returns(ActiveSupport::Multibyte::Chars) }
  def mb_chars; end

  sig { params(separator: String, preserve_case: T::Boolean, locale: T.nilable(Symbol)).returns(String) }
  def parameterize(separator: "-", preserve_case: false, locale: nil); end

  sig { params(count: T.nilable(T.any(Integer, Symbol)), locale: T.nilable(Symbol)).returns(String) }
  def pluralize(count = nil, locale = :en); end

  sig { returns(T::Boolean) }
  def present?; end

  sig { params(patterns: T.any(String, Regexp)).returns(String) }
  def remove(*patterns); end

  sig { params(patterns: T.any(String, Regexp)).returns(String) }
  def remove!(*patterns); end

  sig { returns(T.untyped) }
  def safe_constantize; end

  sig { params(locale: Symbol).returns(String) }
  def singularize(locale = :en); end

  sig { returns(String) }
  def squish; end

  sig { returns(String) }
  def squish!; end

  # alias for `#start_with?`
  sig { params(string_or_regexp: T.any(String, Regexp)).returns(T::Boolean) }
  def starts_with?(*string_or_regexp); end

  sig { returns(String) }
  def strip_heredoc; end

  sig { returns(String) }
  def tableize; end

  sig { params(keep_id_suffix: T::Boolean).returns(String) }
  def titlecase(keep_id_suffix: false); end

  sig { params(keep_id_suffix: T::Boolean).returns(String) }
  def titleize(keep_id_suffix: false); end

  sig { params(position: Integer).returns(String) }
  def to(position); end

  sig { returns(::Date) }
  def to_date; end

  sig { returns(::DateTime) }
  def to_datetime; end

  sig { params(form: T.nilable(Symbol)).returns(T.nilable(Time)) }
  def to_time(form = :local); end

  sig { params(truncate_to: Integer, options: T::Hash[Symbol, T.anything]).returns(String) }
  def truncate(truncate_to, options = {}); end

  sig { params(truncate_to: Integer, omission: T.nilable(String)).returns(String) }
  def truncate_bytes(truncate_to, omission: "…"); end

  sig { params(words_count: Integer, options: T::Hash[Symbol, T.anything]).returns(String) }
  def truncate_words(words_count, options = {}); end

  sig { returns(String) }
  def underscore; end

  sig { returns(String) }
  def upcase_first; end
end

class ActiveSupport::ErrorReporter
  # @version ~> 7.0.0
  sig do
    type_parameters(:Block, :Fallback)
      .params(
        error_class: T.class_of(Exception),
        severity: T.nilable(Symbol),
        context: T.nilable(T::Hash[Symbol, T.untyped]),
        fallback: T.nilable(T.proc.returns(T.type_parameter(:Fallback))),
        blk: T.proc.returns(T.type_parameter(:Block)),
      )
      .returns(T.any(T.type_parameter(:Block), T.type_parameter(:Fallback)))
  end
  def handle(error_class, severity: T.unsafe(nil), context: T.unsafe(nil), fallback: T.unsafe(nil), &blk); end

  # @version >= 7.1.0.beta1
  sig do
    type_parameters(:Block, :Fallback)
      .params(
        error_classes: T.class_of(Exception),
        severity: T.nilable(Symbol),
        context: T.nilable(T::Hash[Symbol, T.untyped]),
        fallback: T.nilable(T.proc.returns(T.type_parameter(:Fallback))),
        source: T.nilable(String),
        blk: T.proc.returns(T.type_parameter(:Block)),
      )
      .returns(T.any(T.type_parameter(:Block), T.type_parameter(:Fallback)))
  end
  def handle(*error_classes, severity: T.unsafe(nil), context: T.unsafe(nil), fallback: T.unsafe(nil), source: T.unsafe(nil), &blk); end

  # @version ~> 7.0.0
  sig do
    type_parameters(:Block)
      .params(
        error_class: T.class_of(Exception),
        severity: T.nilable(Symbol),
        context: T.nilable(T::Hash[Symbol, T.untyped]),
        blk: T.proc.returns(T.type_parameter(:Block)),
      )
      .returns(T.type_parameter(:Block))
  end
  def record(error_class, severity: T.unsafe(nil), context: T.unsafe(nil), &blk); end

  # @version >= 7.1.0.beta1
  sig do
    type_parameters(:Block)
      .params(
        error_classes: T.class_of(Exception),
        severity: T.nilable(Symbol),
        context: T.nilable(T::Hash[Symbol, T.untyped]),
        source: T.nilable(String),
        blk: T.proc.returns(T.type_parameter(:Block)),
      )
      .returns(T.type_parameter(:Block))
  end
  def record(*error_classes, severity: T.unsafe(nil), context: T.unsafe(nil), source: T.unsafe(nil), &blk); end

  # @version ~> 7.0.0
  sig do
    params(
      error: Exception,
      handled: T::Boolean,
      severity: T.nilable(Symbol),
      context: T::Hash[Symbol, T.untyped],
    ).void
  end
  def report(error, handled:, severity: T.unsafe(nil), context: T.unsafe(nil)); end

  # @version >= 7.1.0.beta1
  sig do
    params(
      error: Exception,
      handled: T::Boolean,
      severity: T.nilable(Symbol),
      context: T::Hash[Symbol, T.untyped],
      source: T.nilable(String),
    ).void
  end
  def report(error, handled: true, severity: T.unsafe(nil), context: T.unsafe(nil), source: T.unsafe(nil)); end

  # @version >= 7.2.0.beta1
  sig do
    params(
      error: T.any(Exception, String),
      severity: T.nilable(Symbol),
      context: T::Hash[Symbol, T.untyped],
      source: T.nilable(String),
    ).void
  end
  def unexpected(error, severity: T.unsafe(nil), context: T.unsafe(nil), source: T.unsafe(nil)); end
end

module ActiveSupport::Testing::Assertions
  sig do
    type_parameters(:Block).params(block: T.proc.returns(T.type_parameter(:Block))).returns(T.type_parameter(:Block))
  end
  def assert_nothing_raised(&block); end

  sig do
    type_parameters(:TResult)
      .params(
        expression: T.any(Proc, Kernel),
        message: Kernel,
        from: T.anything,
        to: T.anything,
        block: T.proc.returns(T.type_parameter(:TResult)),
      )
      .returns(T.type_parameter(:TResult))
  end
  def assert_changes(expression, message = T.unsafe(nil), from: T.unsafe(nil), to: T.unsafe(nil), &block); end
end
