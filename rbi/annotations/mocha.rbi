# typed: strict

module Mocha::API
  sig { params(arguments: T.untyped).returns(Mocha::Mock) }
  def mock(*arguments); end

  sig { params(arguments: T.untyped).returns(T.untyped) }
  def stub(*arguments); end
end

module Mocha::ClassMethods
  sig { returns(Mocha::Mock) }
  def any_instance; end
end

class Mocha::Expectation
  sig do
    params(
      expected_parameters_or_matchers: T.untyped,
      _arg1: T.untyped,
      matching_block: T.nilable(T.proc.params(actual_parameters: T.untyped).void)
    ).returns(Mocha::Expectation)
  end
  def with(*expected_parameters_or_matchers, **_arg1, &matching_block); end

  sig { params(values: T.untyped).returns(Mocha::Expectation) }
  def returns(*values); end
end

module Mocha::ObjectMethods
  sig { params(expected_methods_vs_return_values: T.untyped).returns(Mocha::Expectation) }
  def expects(expected_methods_vs_return_values); end

  sig { params(stubbed_methods_vs_return_values: T.untyped).returns(Mocha::Expectation) }
  def stubs(stubbed_methods_vs_return_values); end
end
