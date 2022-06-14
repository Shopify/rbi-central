# typed: strict

module Faraday
  class << self
    sig do
      params(
        url: T.untyped,
        options: T::Hash[Symbol, T.untyped],
        block: T.nilable(T.proc.params(connection: Faraday::Connection).void)
      ).returns(Faraday::Connection)
    end
    def new(url = nil, options = {}, &block); end
  end
end

class Faraday::Response
  sig { returns(T::Boolean) }
  def success?; end
end
