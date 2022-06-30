# typed: strong

module Lhm
  extend Lhm
  extend Lhm::Throttler

  sig { returns(Lhm::Connection) }
  def adapter; end

  sig do
    params(
      table_name: T.any(String, Symbol),
      options: T::Hash[Symbol, T.untyped],
      block: T.proc.params(arg0: Lhm::Migrator).void
    ).returns(TrueClass)
  end
  def change_table(table_name, options = nil, &block); end

  sig { params(run: T.nilable(T::Boolean), options: T.nilable(T::Hash[Symbol, T.untyped])).returns(T::Boolean) }
  def cleanup(run = nil, options = nil); end

  sig { returns(Lhm::Connection) }
  def connection; end

  sig { returns(Logger) }
  def self.logger; end

  sig { params(new_logger: Logger).returns(Logger) }
  def self.logger=(new_logger); end

  sig { params(adapter: Lhm::Connection).returns(Lhm::Connection) }
  def setup(adapter); end
end

class Lhm::Table
  sig { params(name: T.any(String, Symbol), pk: T.nilable(T.any(String, Symbol)), ddl: T.untyped).void }
  def initialize(name, pk = nil, ddl = nil); end

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def columns; end

  sig { returns(T.untyped) }
  def ddl; end

  sig { returns(String) }
  def destination_name; end

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def indices; end

  sig { returns(T.any(String, Symbol)) }
  def name; end

  sig { returns(T.any(String, Symbol)) }
  def pk; end

  sig { returns(T.nilable(T::Boolean)) }
  def satisfies_primary_key?; end

  sig { params(table_name: T.any(Symbol, String), connection: Lhm::Connection).returns(Lhm::Table) }
  def self.parse(table_name, connection); end
end

module Lhm::Command
  sig { params(block: T.nilable(T.proc.params(arg0: Lhm::Command).void)).void }
  def run(&block); end
end

class Lhm::Printer::Output
  sig { params(message: String).void }
  def write(message); end
end

class Lhm::Printer::Base
  sig { void }
  def initialize; end
end

class Lhm::Printer::Percentage < Lhm::Printer::Base
  sig { void }
  def initialize; end

  sig { void }
  def end; end

  sig { params(lowest: Numeric, highest: T.nilable(Numeric)).void }
  def notify(lowest, highest); end
end

class Lhm::Printer::Dot < Lhm::Printer::Base
  sig { void }
  def end; end

  sig { params(lowest: T.nilable(Numeric), highest: T.nilable(Numeric)).void }
  def notify(lowest = nil, highest = nil); end
end

class Lhm::Migrator
  include Lhm::Command
  include Lhm::SqlHelper

  sig { params(table: Lhm::Table, connection: T.nilable(Lhm::Connection)).void }
  def initialize(table, connection = nil); end

  sig do
    params(name: T.any(String, Symbol), definition: T.any(String, Symbol)).void
  end
  def add_column(name, definition); end

  sig do
    params(
      columns: T.any(String, Symbol, T::Array[T.any(String, Symbol)]),
      index_name: T.nilable(String, Symbol)
    ).void
  end
  def add_index(columns, index_name = nil); end

  sig do
    params(
      columns: T.any(String, Symbol, T::Array[T.any(String, Symbol)]),
      index_name: T.nilable(String, Symbol)
    ).void
  end
  def add_unique_index(columns, index_name = nil); end

  sig { params(name: T.any(String, Symbol), definition: T.any(String, Symbol)).void }
  def change_column(name, definition); end

  sig { returns(T::Array[String]) }
  def conditions; end

  sig { returns(T.nilable(Lhm::Connection)) }
  def connection; end

  sig { params(statement: String).void }
  def ddl(statement); end

  sig { params(sql: String).returns(String) }
  def filter(sql); end

  sig { returns(String) }
  def name; end

  sig { params(name: T.any(String, Symbol)).void }
  def remove_column(name); end

  sig do
    params(
      columns: T.any(String, Symbol, T::Array[T.any(String, Symbol)]),
      index_name: T.nilable(String, Symbol)
    ).void
  end
  def remove_index(columns, index_name = nil); end

  sig { params(old: T.any(String, Symbol), nu: T.any(String, Symbol)).void }
  def rename_column(old, nu); end

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  def renames; end

  sig { returns(T::Array[String]) }
  def statements; end
end

module Lhm::Throttler
  sig { params(type: T.any(Lhm::Command, Symbol, String, Class), options: T.nilable(T::Hash[T.untyped, T.untyped])).void }
  def setup_throttler(type, options = nil); end

  sig { returns(T.self_type) }
  def throttler; end
end

class Lhm::Throttler::Time
  include Lhm::Command

  sig { params(options: T.nilable(T::Hash[T.untyped, T.untyped])).void }
  def initialize(options = nil); end

  sig { void }
  def execute; end

  sig { returns(Integer) }
  def stride; end

  sig { params(arg0: Integer).returns(Integer) }
  def stride=(arg0); end

  sig { returns(Numeric) }
  def timeout_seconds; end

  sig { params(arg0: Numeric).returns(Numeric) }
  def timeout_seconds=(arg0); end
end

class Lhm::Throttler::LegacyTime < Lhm::Throttler::Time
  sig { params(timeout: T.nilable(Numeric), stride: T.nilable(Integer)).void }
  def initialize(timeout, stride); end
end

class Lhm::Throttler::Factory
  sig do
    params(
      type: T.any(Lhm::Command, Symbol, String, Class),
      options: T.nilable(T::Hash[T.untyped, T.untyped])
    ).returns(T.untyped)
  end
  def self.create_throttler(type, options = nil); end
end
