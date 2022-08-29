# typed: strict

class ActiveRecord::Schema
  sig {params(info: T::Hash[T.untyped, T.untyped], blk: T.proc.bind(ActiveRecord::Schema).void).void}
  def self.define(info = nil, &blk); end
end

class ActiveRecord::Migration
  # @shim: Methods on migration are delegated to `SchemaStatements` using `method_missing`
  include ActiveRecord::ConnectionAdapters::SchemaStatements
end
