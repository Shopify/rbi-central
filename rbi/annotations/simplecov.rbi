# typed: true

module SimpleCov
  sig { returns(SimpleCov::FormatterInterface) }
  attr_accesor :formatter

  class << self
    sig { params(profile: T.nilable(T.any(String, Symbol)), block: T.proc.bind(SimpleCov::Configuration).void).void }
    def start(profile = nil, &block); end
  end
end

# @shim: Not real at runtime, but describes the interface implemented by
#   - https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/formatter/simple_formatter.rb
#   - https://github.com/simplecov-ruby/simplecov/blob/main/lib/simplecov/formatter/multi_formatter.rb

module SimpleCov::FormatterInterface
  interface!

  sig { abstract.params(result: SimpleCov::Result).returns(String) }
  def format(result); end
end

class SimpleCov::Formatter::SimpleFormatter
  include SimpleCov::FormatterInterface
end

class SimpleCov::Formatter::MultiFormatter
  include SimpleCov::FormatterInterface
end

module SimpleCov::Configuration
  # @shim: a String or Regexp that filters the file paths to be included in the coverage report
  FilterSpec = T.type_alias { T.any(String, Regexp) }

  sig do
    params(
      filter_argument: T.nilable(T.any(FilterSpec, T::Array[FilterSpec])),
      filter_proc: T.nilable(T.proc.params(arg0: SimpleCov::SourceFile).returns(T::Boolean)),
    ).void
  end
  def add_filter(filter_argument = nil, &filter_proc); end

  sig { params(criterion: Symbol).void }
  def enable_coverage(criterion); end
end
