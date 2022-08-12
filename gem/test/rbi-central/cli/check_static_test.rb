# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckStaticTest < TestWithRepo
      def test_static_all_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Gem1; CONST = 42; end")
        @repo.write_annotations_file!("gem2", "module Gem2; CONST = 42; end")
        res = @repo.repo("check static")
        assert_equal(<<~ERR, res.err)
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `gem1`...
          Checking static for `gem2`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_static_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Gem1; end")
        @repo.write_annotations_file!("gem2", <<~RBI)
          class Gem2
            CONST = 42
          end
        RBI
        res = @repo.repo("check static")
        assert_equal(<<~ERR, res.err)
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `gem1`...

          Error: Duplicated RBI for ::Gem1:
           * rbi/annotations/gem1.rbi:1:0-1:16
           * sorbet/rbi/gems/gem1@0.0.1.rbi:8:0-8:16

          Checking static for `gem2`...

          Error: sorbet/rbi/gems/gem2@0.0.1.rbi:8: `Gem2` was previously defined as a `class` https://srb.help/4012
               8 |module Gem2; end
                  ^^^^^^^^^^^

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_static_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Gem1; end")
        res = @repo.repo("check static gem1")
        assert_equal(<<~ERR, res.err)
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `gem1`...

          Error: Duplicated RBI for ::Gem1:
           * rbi/annotations/gem1.rbi:1:0-1:16
           * sorbet/rbi/gems/gem1@0.0.1.rbi:8:0-8:16

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end
    end
  end
end
