# typed: strict
# frozen_string_literal: true

module RBICentral
  extend T::Sig
  extend CLI

  INDEX_PATH = "index.json"

  sig { returns(T::Hash[String, T.untyped]) }
  def self.load_index
    JSON.parse(File.read(INDEX_PATH))
  rescue => e
    error("Can't load index `#{INDEX_PATH}`")
    $stderr.puts("\n#{e.message}\n")
    exit(1)
  end
end
