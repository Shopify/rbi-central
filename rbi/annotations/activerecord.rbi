# typed: strict

class ActiveRecord::Schema
  sig {params(info: T::Hash[T.untyped, T.untyped], blk: T.proc.bind(ActiveRecord::Schema).void).void}
  def self.define(info = nil, &blk); end
end

class ActiveRecord::Migration::Current < ActiveRecord::Migration
  include ActiveRecord::ConnectionAdapters::SchemaStatements
end
