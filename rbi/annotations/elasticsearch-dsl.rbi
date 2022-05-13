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

  sig { params(args: T.untyped).void }
  def source(*args); end
end

class Elasticsearch::DSL::Search::Query
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Filters::Bool).void).void }
  def bool(&block); end

  sig { params(opts: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def filters(**opts, &block); end

  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Queries::FunctionScore).void).void }
  def function_score(&block); end
end

class Elasticsearch::DSL::Search::Aggregation
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Aggregations::DateRange).void).void }
  def date_range(&block); end

  sig { params(opts: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def filters(**opts, &block); end
end

class Elasticsearch::DSL::Search::Filters::Bool
  sig { params(block: T.proc.bind(Elasticsearch::DSL::Search::Filter).void).void }
  def filter(&block); end

  sig { params(args: T.untyped, block: T.proc.bind(Elasticsearch::DSL::Search::Filter).void).void }
  def should(*args, &block); end
end

class Elasticsearch::DSL::Search::Filter
  sig { params(value: T.nilable(T.any(String, Symbol)), block: T.proc.bind(Elasticsearch::DSL::Search::Queries::QueryString).void).void }
  def query_string(value = nil, &block); end

  sig { params(value: T.any(String, Symbol), block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Queries::Prefix).void)).void }
  def prefix(value, &block); end

  sig { params(value: T.untyped).void }
  def term(value); end
end

class Elasticsearch::DSL::Search::Queries::FunctionScore
  sig { params(args: T.untyped, block: T.nilable(T.proc.bind(Elasticsearch::DSL::Search::Query).void)).void }
  def query(*args, &block); end
end
