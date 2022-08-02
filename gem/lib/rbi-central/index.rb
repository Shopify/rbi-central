# typed: strict
# frozen_string_literal: true

module RBICentral
  class Index < T::Struct
    extend T::Sig

    const :gems, T::Hash[String, Gem], default: {}

    class Error < RBICentral::Error; end

    sig { params(object: T::Hash[String, T.untyped]).returns(Index) }
    def self.from_object(object)
      Index.new(gems: object.map { |name, gem_object| [name, Gem.from_object(name, gem_object)] }.to_h)
    end

    sig { params(before: Index, after: Index).returns(ChangeSet) }
    def self.compare(before:, after:)
      ChangeSet.new(
        before: before,
        after: after,
        added: after.gems.values.select { |gem| !before.gem?(gem.name) },
        removed: before.gems.values.select { |gem| !after.gem?(gem.name) },
        updated: before.gems.values.select { |gem| after.gem?(gem.name) && after[gem.name] != gem }
      )
    end

    sig { params(name: String).returns(Gem) }
    def [](name)
      if gem?(name)
        gems.fetch(name)
      else
        raise Error, "No gem named `#{name}` in index"
      end
    end

    sig { params(gem: Gem).void }
    def <<(gem)
      gems[gem.name] = gem
    end

    sig { params(name: String).returns(T::Boolean) }
    def gem?(name)
      gems.key?(name)
    end

    sig { returns(T::Array[Gem]) }
    def all_gems
      gems.sort.map { |_name, gem| gem }
    end

    sig { params(names: T::Array[String]).returns(T::Array[Gem]) }
    def target_gems(names)
      names.empty? ? all_gems : gems_from_names(names)
    end

    sig { params(names: T::Array[String]).returns(T::Array[Gem]) }
    def gems_from_names(names)
      names.sort.map { |name| self[name] }
    end

    sig { returns(String) }
    def to_formatted_json
      JSON.pretty_generate(gems.sort.map { |name, gem| [name, gem.to_object] }.to_h) + "\n"
    end

    class ChangeSet < T::Struct
      extend T::Sig

      const :before, Index
      const :after, Index

      const :added, T::Array[Gem], default: []
      const :removed, T::Array[Gem], default: []
      const :updated, T::Array[Gem], default: []

      sig { returns(T::Boolean) }
      def empty?
        added.empty? && removed.empty? && updated.empty?
      end
    end
  end
end
