# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckRubocopTest < TestWithRepo
      include CLI::Helper

      def test_rubocop_empty_index
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check rubocop")
        assert_includes(res.err, <<~ERR)
          ### Linting RBI files...
        ERR
        assert_includes(res.err, <<~ERR)
          0 files inspected, no offenses detected

          No errors, good job!
        ERR
        assert(res.status)
      end

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
        assert_includes(res.err, <<~ERR)
          ### Linting RBI files...
        ERR
        assert_includes(res.err, <<~ERR)
          2 files inspected, no offenses detected

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
        res = @repo.repo("check rubocop rbi/annotations/gem2.rbi")
        assert_includes(res.err, <<~ERR)
          ### Linting RBI files...
        ERR
        assert_includes(res.err, <<~ERR)
          1 file inspected, no offenses detected

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
        assert_includes(res.err, <<~ERR)
          ### Linting RBI files...
        ERR
        assert_includes(res.err, <<~ERR)
          rbi/annotations/gem1.rbi:1:1: C: Sorbet/StrictSigil: Sorbet sigil should be at least strict got true.
        ERR
        assert_includes(res.err, <<~ERR)
          rbi/annotations/gem2.rbi:3:1: C: [Correctable] Sorbet/SingleLineRbiClassModuleDefinitions: Empty class/module definitions in RBI files should be on a single line.
        ERR
        assert_includes(res.err, <<~ERR)
          2 files inspected, 2 offenses detected, 1 offense autocorrectable

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
        res = @repo.repo("check rubocop rbi/annotations/gem2.rbi")
        assert_includes(res.err, <<~ERR)
          ### Linting RBI files...
        ERR
        assert_includes(res.err, <<~ERR)
          rbi/annotations/gem2.rbi:1:1: C: Sorbet/StrictSigil: Sorbet sigil should be at least strict got true.
        ERR
        assert_includes(res.err, <<~ERR)
          1 file inspected, 1 offense detected

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end
    end
  end
end
