# typed: true

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

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        params: T.nilable(T::Hash[T.untyped, T.untyped]),
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def get(url = nil, params = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        params: T.nilable(T::Hash[T.untyped, T.untyped]),
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def head(url = nil, params = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        params: T.nilable(T::Hash[T.untyped, T.untyped]),
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def delete(url = nil, params = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        params: T.nilable(T::Hash[T.untyped, T.untyped]),
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def trace(url = nil, params = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        body: T.untyped,
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def post(url = nil, body = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        body: T.untyped,
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def put(url = nil, body = nil, headers = nil, &block); end

    # @method_missing: proxied to Faraday.default_connection, a Faraday::Connection
    sig do
      params(
        url: T.nilable(T.any(String, URI::Generic)),
        body: T.untyped,
        headers: T.nilable(T::Hash[T.untyped, T.untyped]),
        block: T.nilable(T.proc.params(request: Faraday::Request).void)
      ).returns(Faraday::Response)
    end
    def patch(url = nil, body = nil, headers = nil, &block); end
  end
end

class Faraday::Response
  sig { returns(T::Boolean) }
  def success?; end
end
