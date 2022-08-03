# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckRuntimeTest < TestWithRepo
      include CLI::Helper

      def test_runtime_empty_index
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check runtime")
        assert_equal(<<~ERR, res.err)
          ### Checking RBI files against runtime execution...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_runtime_all_valid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module RBI; end")
        @repo.write_annotations_file!("spoom", "module Spoom; end")
        res = @repo.repo("check runtime")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against runtime execution...

          Checking runtime for `rbi`...
          Checking runtime for `spoom`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_runtime_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module NotFound; end")
        @repo.write_annotations_file!("spoom", "module NotFound; end")
        res = @repo.repo("check runtime")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against runtime execution...

          Checking runtime for `rbi`...
          Error: Missing runtime constant `::NotFound` (defined at `./rbi/annotations/rbi.rbi:1:0-1:20`)
          Checking runtime for `spoom`...
          Error: Missing runtime constant `::NotFound` (defined at `./rbi/annotations/spoom.rbi:1:0-1:20`)

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_runtime_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module NotFound; end")
        res = @repo.repo("check runtime rbi/annotations/rbi.rbi")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against runtime execution...

          Checking runtime for `rbi`...
          Error: Missing runtime constant `::NotFound` (defined at `rbi/annotations/rbi.rbi:1:0-1:20`)

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      private

      sig { params(message: String).returns(String) }
      def filter(message)
        message
          .gsub(/warning:.*\n/, "")
          .gsub(/Please.*\n/, "")
      end
    end
  end
end
