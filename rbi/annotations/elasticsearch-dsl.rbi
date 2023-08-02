# typed: true

module Elasticsearch::DSL::Search
  sig { params(args: T.untyped, block: T.proc.bind(Elasticsearch::DSL::Search::Search).void).void }
  def self.search(*args, &block); end
end

class Elasticsearch::DSL::Search::Search
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def query(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Aggregation).void)).void }
  def aggregation(*args, &block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Options
  sig { params(args: T.untyped).void }
  def source(*args); end
end

class Elasticsearch::DSL::Search::Query
  # @method_missing: delegated to Elasticsearch::DSL::Search::Queries::Bool
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Filters::Bool).void).void }
  def bool(&block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Aggregations::Filters
  sig { params(opts: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def filters(**opts, &block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Queries::FunctionScore
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Queries::FunctionScore).void).void }
  def function_score(&block); end
end

class Elasticsearch::DSL::Search::Aggregation
  # @method_missing: delegated to Elasticsearch::DSL::Search::Aggregations::DateRange
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Aggregations::DateRange).void).void }
  def date_range(&block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Aggregations::Filters
  sig { params(opts: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def filters(**opts, &block); end
end

class Elasticsearch::DSL::Search::Filters::Bool
  # @method_missing: delegated to Elasticsearch::DSL::Search::Filter
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Filter).void).void }
  def filter(&block); end

  sig { params(args: T.untyped, block: T.proc.bind(Elasticsearch::DSL::Search::Filter).void).void }
  def should(*args, &block); end
end

class Elasticsearch::DSL::Search::Filter
  # @method_missing: delegated to Elasticsearch::DSL::Search::Queries::QueryString
  sig { params(value: T.nilable(T.any(String, Symbol)), block: T.proc.bind(Elasticsearch::DSL::Search::Queries::QueryString).void).void }
  def query_string(value = nil, &block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Queries::Prefix
  sig { params(value: T.any(String, Symbol), block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Queries::Prefix).void)).void }
  def prefix(value, &block); end

  # @method_missing: delegated to Elasticsearch::DSL::Search::Queries::Term
  sig { params(value: T.untyped).void }
  def term(value); end
end

class Elasticsearch::DSL::Search::Queries::FunctionScore
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def query(*args, &block); end
end
