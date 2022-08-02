# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  class IndexTest < Test
    def test_from_object
      index = Index.from_object({})
      assert_equal({}, index.gems)

      index = Index.from_object({
        "gem1" => {},
        "gem2" => { "requires" => ["x"], "dependencies" => ["a", "b"] },
      })
      assert_equal(2, index.gems.size)
      assert_equal("gem1", index.gems["gem1"]&.name)
      assert_equal([], index.gems["gem1"]&.requires)
      assert_equal([], index.gems["gem1"]&.dependencies)
      assert_equal("gem2", index.gems["gem2"]&.name)
      assert_equal(["x"], index.gems["gem2"]&.requires)
      assert_equal(["a", "b"], index.gems["gem2"]&.dependencies)
    end

    def test_get_gem_not_found
      index = Index.new
      error = assert_raises(Index::Error) do
        index["gem1"]
      end
      assert_equal("No gem named `gem1` in index", error.message)
    end

    def test_get_gem
      index = Index.new
      index << Gem.new(name: "gem1")
      assert_equal("gem1", index["gem1"].name)
    end

    def test_all_gems
      index = Index.new
      index << Gem.new(name: "gem2")
      index << Gem.new(name: "gem1")
      index << Gem.new(name: "gem3")
      assert_equal(["gem1", "gem2", "gem3"], index.all_gems.map(&:name))
    end

    def test_gems_from_names_not_found
      index = Index.new
      error = assert_raises(Index::Error) do
        index.gems_from_names(["gem1"])
      end
      assert_equal("No gem named `gem1` in index", error.message)
    end

    def test_gems_from_names
      index = Index.new
      index << Gem.new(name: "gem2")
      index << Gem.new(name: "gem1")
      index << Gem.new(name: "gem3")
      assert_equal(["gem1", "gem2"], index.gems_from_names(["gem2", "gem1"]).map(&:name))
    end

    def test_target_gems_not_found
      index = Index.new
      error = assert_raises(Index::Error) do
        index.target_gems(["gem1"])
      end
      assert_equal("No gem named `gem1` in index", error.message)
    end

    def test_target_gems
      index = Index.new
      index << Gem.new(name: "gem2")
      index << Gem.new(name: "gem1")
      index << Gem.new(name: "gem3")
      assert_equal(["gem1", "gem2", "gem3"], index.target_gems([]).map(&:name))
      assert_equal(["gem1", "gem2"], index.target_gems(["gem1", "gem2"]).map(&:name))
      assert_equal(["gem3"], index.target_gems(["gem3"]).map(&:name))
    end

    def test_to_formatted_json
      index = Index.new(gems: {
        "gem2" => Gem.new(name: "gem2", requires: ["x"], dependencies: ["a", "b"]),
        "gem1" => Gem.new(name: "gem1"),
      })
      assert_equal(<<~JSON, index.to_formatted_json)
        {
          "gem1": {
          },
          "gem2": {
            "dependencies": [
              "a",
              "b"
            ],
            "requires": [
              "x"
            ]
          }
        }
      JSON
    end

    def test_compare_with
      before = Index.new
      before << Gem.new(name: "gem1")
      before << Gem.new(name: "gem2")
      before << Gem.new(name: "gem3")

      after = Index.new
      after << Gem.new(name: "gem1")
      after << Gem.new(name: "gem3", dependencies: ["a", "b"])
      after << Gem.new(name: "gem4")
      after << Gem.new(name: "gem5")

      changes = Index.compare(before: before, after: after)
      assert_equal(["gem2"], changes.removed.map(&:name))
      assert_equal(["gem3"], changes.updated.map(&:name))
      assert_equal(["gem4", "gem5"], changes.added.map(&:name))
    end
  end
end
