# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckRubocopTest < TestWithRepo
      def test_rubocop_all_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {},
            "gem2": {}
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          # typed: strict

          module Gem1; end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: strict

          module Gem2; end
        RBI
        res = @repo.repo("check rubocop")
        assert_equal(<<~ERR, res.err)
          ### Linting RBI files...

          Linting `gem1`...
          Linting `gem2`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_rubocop_one_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {},
            "gem2": {}
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          module Gem1; end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: strict

          module Gem2; end
        RBI
        res = @repo.repo("check rubocop gem2")
        assert_equal(<<~ERR, res.err)
          ### Linting RBI files...

          Linting `gem2`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_rubocop_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {},
            "gem2": {}
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          # typed: true

          module Gem1; end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: strict

          module Gem2
          end
        RBI
        res = @repo.repo("check rubocop")
        assert_equal(<<~ERR, res.err)
          ### Linting RBI files...

          Linting `gem1`...

          Error: rbi/annotations/gem1.rbi:1:1: C: Sorbet/StrictSigil: Sorbet sigil should be at least strict got true.
          # typed: true
          ^^^^^^^^^^^^^

          Linting `gem2`...

          Error: rbi/annotations/gem2.rbi:3:1: C: [Correctable] Sorbet/SingleLineRbiClassModuleDefinitions: Empty class/module definitions in RBI files should be on a single line.
          module Gem2 ...
          ^^^^^^^^^^^

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_rubocop_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {},
            "gem2": {}
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          module Gem1; end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: true

          module Gem2; end
        RBI
        res = @repo.repo("check rubocop gem2")
        assert_equal(<<~ERR, res.err)
          ### Linting RBI files...

          Linting `gem2`...

          Error: rbi/annotations/gem2.rbi:1:1: C: Sorbet/StrictSigil: Sorbet sigil should be at least strict got true.
          # typed: true
          ^^^^^^^^^^^^^

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end
    end
  end
end
