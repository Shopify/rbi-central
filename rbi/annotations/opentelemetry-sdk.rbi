# typed: true

module OpenTelemetry
  sig { returns(OpenTelemetry::Trace::TracerProvider) }
  def self.tracer_provider; end
end

class OpenTelemetry::Trace::TracerProvider
  sig { params(name: T.nilable(String), version: T.nilable(String)).returns(OpenTelemetry::Trace::Tracer) }
  def tracer(name = nil, version = nil); end
end

class OpenTelemetry::Trace::Tracer
  sig do
    params(
      name: String,
      with_parent: T.nilable(OpenTelemetry::Trace::Span),
      attributes: T.nilable(T::Hash[String, T.untyped]),
      links: T.nilable(T::Array[OpenTelemetry::Trace::Link]),
      start_timestamp: T.nilable(Integer),
      kind: T.nilable(Symbol)
    )
      .returns(OpenTelemetry::Trace::Span)
  end
  def start_span(name, with_parent: nil, attributes: nil, links: nil, start_timestamp: nil, kind: nil); end
end

class OpenTelemetry::Trace::Span
  sig { params(key: String, value: T.untyped).returns(T.self_type) }
  def set_attribute(key, value); end

  sig { params(end_timestamp: Integer).void }
  def finish(end_timestamp: nil); end
end
