# typed: strong

module Lhm
  extend Lhm

  sig do
    params(
      table_name: T.any(String, Symbol),
      options: T::Hash[Symbol, T.untyped],
      block: T.proc.params(arg0: Lhm::Migrator).void
    ).returns(T::Boolean)
  end
  def change_table(table_name, options = {}, &block); end

  sig { params(run: T::Boolean, options: T.nilable(T::Hash[Symbol, T.untyped])).void }
  def cleanup(run = false, options = {}); end

  sig { returns(Lhm::Connection) }
  def connection; end

  sig { returns(Logger) }
  def self.logger; end

  sig { params(new_logger: Logger).returns(Logger) }
  def self.logger=(new_logger); end

  sig { params(adapter: Lhm::Connection).void }
  def setup(adapter); end
end

class Lhm::Table
  sig { returns(T::Hash[T.untyped, T.untyped]) }
  attr_reader :columns

  sig { returns(T.untyped) }
  attr_reader :ddl

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  attr_reader :indices

  sig { returns(T.any(String, Symbol)) }
  attr_reader :name

  sig { returns(T.any(String, Symbol)) }
  attr_reader :pk

  sig { params(name: T.any(String, Symbol), pk: T.any(String, Symbol), ddl: T.untyped).void }
  def initialize(name, pk = "id", ddl = nil); end

  sig { returns(String) }
  def destination_name; end

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

class Lhm::Printer::Percentage
  sig { void }
  def end; end

  sig { params(lowest: Numeric, highest: T.nilable(Numeric)).void }
  def notify(lowest, highest); end
end

class Lhm::Printer::Dot < Lhm::Printer::Base
  sig { void }
  def end; end

  sig { params(_arg0: T.untyped).void }
  def notify(*_arg0); end
end

class Lhm::Migrator
  include Lhm::Command

  sig { returns(String) }
  attr_reader :name

  sig { returns(T::Array[String]) }
  attr_reader :statements

  sig { returns(T.nilable(Lhm::Connection)) }
  attr_reader :connection

  sig { returns(T::Array[String]) }
  attr_reader :conditions

  sig { returns(T::Hash[T.untyped, T.untyped]) }
  attr_reader :renames

  sig { returns(Lhm::Table) }
  attr_reader :origin

  sig { params(table: Lhm::Table, connection: T.nilable(Lhm::Connection)).void }
  def initialize(table, connection = nil); end

  sig { params(name: T.any(String, Symbol), definition: T.any(String, Symbol)).void }
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

  sig { params(statement: String).void }
  def ddl(statement); end

  sig { params(sql: String).returns(String) }
  def filter(sql); end

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
end

module Lhm::Throttler
  sig { params(type: T.any(Lhm::Command, Symbol, String, T::Class[T.anything]), options: T::Hash[T.untyped, T.untyped]).void }
  def setup_throttler(type, options = {}); end

  sig { returns(Lhm::Throttler) }
  def throttler; end
end

class Lhm::Throttler::Time
  include Lhm::Command

  sig { returns(Integer) }
  attr_accessor :stride

  sig { returns(Numeric) }
  attr_accessor :timeout_seconds

  sig { params(options: T::Hash[T.untyped, T.untyped]).void }
  def initialize(options = {}); end

  sig { void }
  def execute; end
end

class Lhm::Throttler::LegacyTime < Lhm::Throttler::Time
  sig { params(timeout: T.nilable(Numeric), stride: T.nilable(Integer)).void }
  def initialize(timeout, stride); end
end

class Lhm::Throttler::Factory
  sig do
    params(
      type: T.any(Lhm::Command, Symbol, String, T::Class[T.anything]),
      options: T::Hash[T.untyped, T.untyped]
    ).returns(Lhm::Throttler)
  end
  def self.create_throttler(type, options = {}); end
end
