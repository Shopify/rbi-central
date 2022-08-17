# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  class GemTest < Test
    def test_from_object
      gem = Gem.from_object("test")
      assert_equal("test", gem.name)
      assert_equal([], gem.requires)
      assert_equal([], gem.dependencies)

      gem = Gem.from_object("test", { "requires" => ["x"], "dependencies" => ["a", "b"] })
      assert_equal("test", gem.name)
      assert_equal(["x"], gem.requires)
      assert_equal(["a", "b"], gem.dependencies)
    end

    def test_to_object
      gem = Gem.new(name: "test")
      assert_equal({}, gem.to_object)

      gem = Gem.new(name: "test", requires: ["x"], dependencies: ["a", "b"])
      assert_equal({ "requires" => ["x"], "dependencies" => ["a", "b"] }, gem.to_object)
    end

    def test_equality
      gem = Gem.new(name: "foo", path: "path", source: "src", requires: ["x"], dependencies: ["a", "b"])
      same = Gem.new(name: "foo", path: "path", source: "src", requires: ["x"], dependencies: ["a", "b"])
      diff_name = Gem.new(name: "bar")
      diff_source = Gem.new(name: "foo", source: "bar")
      diff_dependencies = Gem.new(name: "foo", dependencies: ["bar"])
      diff_requires = Gem.new(name: "foo", requires: ["bar"])
      assert_equal(gem, same)
      refute_equal(gem, diff_name)
      refute_equal(gem, diff_name)
      refute_equal(gem, diff_source)
      refute_equal(gem, diff_dependencies)
      refute_equal(gem, diff_requires)
    end

    def test_belongs_to_rubygems
      gem = Gem.new(name: "rbi")
      assert(gem.belongs_to_rubygems?)

      gem = Gem.new(name: "a-non-existent-gem")
      refute(gem.belongs_to_rubygems?)

      gem = Gem.new(name: "shopify_lhm")
      refute(gem.belongs_to_rubygems?)
    end
  end
end
