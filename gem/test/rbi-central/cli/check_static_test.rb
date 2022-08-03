# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckStaticTest < TestWithRepo
      include CLI::Helper

      def test_static_empty_index
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check static")
        assert_equal(<<~ERR, res.err)
          ### Checking RBI files against Tapioca and Sorbet...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_static_all_valid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module RBI; CONST = 42; end")
        @repo.write_annotations_file!("spoom", "module Spoom; CONST = 42; end")
        res = @repo.repo("check static")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `rbi`...
          Checking static for `spoom`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_static_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module RBI; end")
        @repo.write_annotations_file!("spoom", <<~RBI)
          class Spoom
            CONST = 42
          end
        RBI
        res = @repo.repo("check static")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `rbi`...
          Error: Duplicated RBI for ::RBI:
          * rbi/annotations/rbi.rbi:1:0-1:15
          * sorbet/rbi/gems/rbi@0.0.15.rbi:7:0-7:15
          * sorbet/rbi/gems/tapioca@0.9.0.pre-8ce7951f69aa41ce9ff4990b67f0c3c9d64c0a6f.rbi:18:0-18:15
          Checking static for `spoom`...
          sorbet/rbi/gems/spoom@1.1.11.rbi:7: `Spoom` was previously defined as a `class` https://srb.help/4012
               7 |module Spoom
                  ^^^^^^^^^^^^

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_static_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "module RBI; end")
        res = @repo.repo("check static rbi/annotations/rbi.rbi")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `rbi`...
          Error: Duplicated RBI for ::RBI:
          * rbi/annotations/rbi.rbi:1:0-1:15
          * sorbet/rbi/gems/rbi@0.0.15.rbi:7:0-7:15
          * sorbet/rbi/gems/tapioca@0.9.0.pre-8ce7951f69aa41ce9ff4990b67f0c3c9d64c0a6f.rbi:18:0-18:15

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
