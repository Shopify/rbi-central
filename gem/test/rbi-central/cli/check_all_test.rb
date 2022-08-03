# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckAllTest < TestWithRepo
      include CLI::Helper

      def test_all_empty_index
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check all")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking index...

          No errors, good job!

          ### Linting RBI files...

          Inspecting 0 files


          0 files inspected, no offenses detected

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          No errors, good job!

          ### Checking RBI files against runtime execution...

          No errors, good job!

          ### Checking RBI files against Tapioca and Sorbet...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_index_all_valid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {
            },
            "spoom": {
            }
          }
        JSON
        @repo.write_annotations_file!("rbi", <<~RBI)
          # typed: strict

          class RBI::ASTVisitor
            abstract!
          end
        RBI
        @repo.write_annotations_file!("spoom", <<~RBI)
          # typed: strict

          module Spoom::Cli
            abstract!
          end
        RBI
        res = @repo.repo("check all")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking index...

          No errors, good job!

          ### Linting RBI files...

          Inspecting 2 files
          ..

          2 files inspected, no offenses detected

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `rbi`...
          Checking Rubygems for `spoom`...

          No errors, good job!

          ### Checking RBI files against runtime execution...

          Checking runtime for `rbi`...
          Checking runtime for `spoom`...

          No errors, good job!

          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `rbi`...
          Checking static for `spoom`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_index_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {
            },
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", <<~RBI)
          class RBI::NotFound; end
        RBI
        @repo.write_annotations_file!("spoom", <<~RBI)
          # typed: strict

          module Spoom::Cli
            abstract!
          end
        RBI
        res = @repo.repo("check all")
        assert_equal(<<~ERR, filter(res.err))
          ### Checking index...

          Error: Formatting errors found in `index.json`:
          --- expected
          +++ index.json
          @@ -1,5 +1,6 @@
           {
             \"rbi\": {
             },
          -  \"spoom\": {}
          +  \"spoom\": {
          +  }
           }

          ### Linting RBI files...

          Inspecting 2 files
          C.

          Offenses:

          rbi/annotations/rbi.rbi:1:1: C: [Correctable] Sorbet/StrictSigil: No Sorbet sigil found in file. Try a typed: strict to start (you can also use rubocop -a to automatically add this).
          class RBI::NotFound; end
          ^^^^^
          rbi/annotations/rbi.rbi:1:1: C: [Correctable] Sorbet/ValidSigil: No Sorbet sigil found in file. Try a typed: true to start (you can also use rubocop -a to automatically add this).
          class RBI::NotFound; end
          ^^^^^

          2 files inspected, 2 offenses detected, 2 offenses autocorrectable

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `rbi`...
          Checking Rubygems for `spoom`...

          No errors, good job!

          ### Checking RBI files against runtime execution...

          Checking runtime for `rbi`...
          Error: Missing runtime constant `::RBI::NotFound` (defined at `./rbi/annotations/rbi.rbi:1:0-1:24`)
          Checking runtime for `spoom`...

          ### Checking RBI files against Tapioca and Sorbet...

          Checking static for `rbi`...
          Checking static for `spoom`...

          No errors, good job!

          Error: Some checks failed. See above for details.
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
