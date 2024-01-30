# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckIndexTest < TestWithRepo
      def test_index_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        res = @repo.repo("check index")
        assert_equal(<<~ERR, res.err)
          ### Checking index...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_index_with_schema_errors
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "foo": 42
            }
          }
        JSON
        res = @repo.repo("check index")
        assert_equal(<<~ERR, res.err)
          ### Checking index...

          Error: The property `#/gem1` contains additional properties ["foo"] outside of the schema when none are allowed

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_index_with_other_errors
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
            },
            "gem2": {},
            "gem3": {
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.write_annotations_file!("gem2", "<rbi>")
        @repo.write_annotations_file!("gem4", "<rbi>")
        @repo.write!("#{@repo.annotations_path}/gem5.rb", "<rbi>")
        res = @repo.repo("check index")
        assert_equal(<<~ERR, res.err)
          ### Checking index...

          Error: Unexpected RBI annotations file `rbi/annotations/gem5.rb` (should have `.rbi` extension)
          Error: Missing index entry for `rbi/annotations/gem4.rbi` (key `gem4` not found in `index.json`)
          Error: Missing RBI annotations file for `gem3` (file `rbi/annotations/gem3.rbi` not found)
          Error: Formatting errors found in `index.json`:
          --- expected
          +++ index.json
          @@ -1,8 +1,7 @@
           {
             "gem1": {
             },
          -  "gem2": {
          -  },
          +  "gem2": {},
             "gem3": {
             }
           }

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end
    end
  end
end
