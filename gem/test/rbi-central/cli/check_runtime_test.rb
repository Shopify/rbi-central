# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckRuntimeTest < TestWithRepo
      def test_runtime_all_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Gem1; end")
        @repo.write_annotations_file!("gem2", "module Gem2; end")
        res = @repo.repo("check runtime")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...
          Checking runtime for `gem2`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_runtime_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module NotFound; end")
        @repo.write_annotations_file!("gem2", "module NotFound; end")
        res = @repo.repo("check runtime")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...

          Error: Missing runtime constant `::NotFound` (defined at `rbi/annotations/gem1.rbi:1:0-1:20`)

          Checking runtime for `gem2`...

          Error: Missing runtime constant `::NotFound` (defined at `rbi/annotations/gem2.rbi:1:0-1:20`)

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_runtime_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1").absolute_path}" },
            "gem2": { "path": "#{@repo.add_mock_gem("gem2").absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module NotFound; end")
        res = @repo.repo("check runtime gem1")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...

          Error: Missing runtime constant `::NotFound` (defined at `rbi/annotations/gem1.rbi:1:0-1:20`)

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_runtime_filters_versioned_annotations
        @repo.write_index!(<<~JSON)
          {
            "gem1": { "path": "#{@repo.add_mock_gem("gem1", version: "2.0.0").absolute_path}" }
          }
        JSON
        # The `old_method` is annotated with @version < 2.0.0, so it should be filtered out
        # when checking against gem1 version 2.0.0. Without filtering, this would fail
        # because `old_method` doesn't exist in the gem.
        @repo.write_annotations_file!("gem1", <<~RBI)
          module Gem1
            # @version < 2.0.0
            def old_method; end
          end
        RBI
        res = @repo.repo("check runtime gem1")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...

          No errors, good job!
        ERR
        assert(res.status)
      end
    end
  end
end
