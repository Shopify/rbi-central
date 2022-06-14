# typed: strict

class ActionDispatch::Routing::RouteSet
  sig { params(block: T.proc.bind(ActionDispatch::Routing::Mapper).void).void }
  def draw(&block); end
end

module ActionDispatch::Integration::Runner
  # Delegated to ActionDispatch::Integration::Session using `method_missing`
  sig { params(host: String).returns(String) }
  def host!(host); end

  # Delegated to ActionDispatch::Integration::Session using `method_missing`
  sig { params(flag: T::Boolean).returns(T::Boolean) }
  def https!(flag = true); end
end

class ActionDispatch::IntegrationTest
  private

  sig { returns(ActionDispatch::TestResponse) }
  attr_reader :response
end
