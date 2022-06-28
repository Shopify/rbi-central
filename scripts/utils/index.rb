require "json"
require_relative "cli"

INDEX_PATH = "index.json"

def load_index
  JSON.parse(File.read(INDEX_PATH))
rescue => e
  error("Can't load index `#{INDEX_PATH}`")
  $stderr.puts("\n#{e.message}\n")
  exit(1)
end
