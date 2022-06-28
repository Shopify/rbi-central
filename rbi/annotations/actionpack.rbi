# typed: strict

class ActionDispatch::Routing::RouteSet
  sig { params(block: T.proc.bind(ActionDispatch::Routing::Mapper).void).void }
  def draw(&block); end
end

module ActionDispatch::Integration::Runner
  # @method_missing: delegated to ActionDispatch::Integration::Session
  sig { params(host: String).returns(String) }
  def host!(host); end

  # @method_missing: delegated to ActionDispatch::Integration::Session
  sig { params(flag: T::Boolean).returns(T::Boolean) }
  def https!(flag = true); end
end

class ActionDispatch::IntegrationTest
  private

  # @method_missing: delegated to ActionDispatch::Integration::Session
  sig { returns(ActionDispatch::TestResponse) }
  attr_reader :response
end
