# typed: strict
# frozen_string_literal: true

module RBICentral
  class Gem < T::Struct
    extend T::Sig

    class Error < RBICentral::Error; end

    const :name, String
    const :path, T.nilable(String), default: nil
    const :source, T.nilable(String), default: nil
    const :dependencies, T::Array[String], default: []
    const :requires, T::Array[String], default: []
    const :skip_exported_rbis, T::Boolean, default: false

    class << self
      extend T::Sig
      sig { params(name: String, object: T::Hash[String, T.untyped]).returns(Gem) }
      def from_object(name, object = {})
        Gem.new(
          name: name,
          path: object["path"],
          source: object["source"],
          dependencies: object["dependencies"] || [],
          requires: object["requires"] || [],
          skip_exported_rbis: object["skip_exported_rbis"] || false,
        )
      end
    end

    sig { params(_args: T.untyped).returns(T::Hash[String, T.untyped]) }
    def to_object(*_args)
      object = T.let({}, T::Hash[String, T.untyped])
      object["path"] = path if path
      object["source"] = source if source
      object["dependencies"] = dependencies if dependencies.any?
      object["requires"] = requires if requires.any?
      object["skip_exported_rbis"] = skip_exported_rbis if skip_exported_rbis
      object
    end

    sig { returns(T::Boolean) }
    def belongs_to_rubygems?
      uri = URI("https://rubygems.org/api/v1/versions/#{@name}/latest.json")
      content = Net::HTTP.get(uri)
      version = JSON.parse(content)["version"]

      version && version != "9001.0" && version != "unknown"
    end

    sig { params(other: Gem).returns(T::Boolean) }
    def ==(other)
      name == other.name &&
        source == other.source &&
        dependencies == other.dependencies &&
        requires == other.requires &&
        skip_exported_rbis == other.skip_exported_rbis
    end

    sig { returns(String) }
    def to_s
      name
    end
  end
end
