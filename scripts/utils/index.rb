require "json"

INDEX_PATH = "index.json"

def load_index
  JSON.parse(File.read(INDEX_PATH))
rescue => e
  $stderr.puts("Error: Can't load index `#{index_file}`: #{e.message}")
  exit(1)
end
