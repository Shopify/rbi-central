# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckRubygemsTest < TestWithRepo
      include CLI::Helper

      def test_rubygems_empty_index
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check rubygems")
        assert_equal(<<~ERR, res.err)
          ### Checking that RBI files belong to public gems...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_rubygems_all_valid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "<rbi>")
        @repo.write_annotations_file!("spoom", "<rbi>")
        res = @repo.repo("check rubygems")
        assert_equal(<<~ERR, res.err)
          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `rbi`...
          Checking Rubygems for `spoom`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_rubygems_one_valid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "<rbi>")
        @repo.write_annotations_file!("spoom", "<rbi>")
        res = @repo.repo("check rubygems spoom")
        assert_equal(<<~ERR, res.err)
          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `spoom`...

          No errors, good job!
        ERR
        assert(res.status)
      end

      def test_rubygems_all_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "some_gem_not_found": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "<rbi>")
        @repo.write_annotations_file!("some_gem_not_found", "<rbi>")
        @repo.write_annotations_file!("spoom", "<rbi>")
        res = @repo.repo("check rubygems")
        assert_equal(<<~ERR, res.err)
          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `rbi`...
          Checking Rubygems for `some_gem_not_found`...
          Error: `some_gem_not_found` doesn't seem to be a public
             Make sure your gem is available at https://rubygems.org/gems/some_gem_not_found
          Checking Rubygems for `spoom`...

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_rubygems_one_invalid
        @repo.write_index!(<<~JSON)
          {
            "rbi": {},
            "some_gem_not_found": {},
            "spoom": {}
          }
        JSON
        @repo.write_annotations_file!("rbi", "<rbi>")
        @repo.write_annotations_file!("some_gem_not_found", "<rbi>")
        @repo.write_annotations_file!("spoom", "<rbi>")
        res = @repo.repo("check rubygems some_gem_not_found")
        assert_equal(<<~ERR, res.err)
          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `some_gem_not_found`...
          Error: `some_gem_not_found` doesn't seem to be a public
             Make sure your gem is available at https://rubygems.org/gems/some_gem_not_found

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end
    end
  end
end
