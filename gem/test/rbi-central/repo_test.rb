# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  class RepoTest < TestWithRepo
    def test_index_missing
      e = assert_raises(RBICentral::Index::Error) do
        @repo.index
      end
      assert_equal("Missing index file `index.json`", e.message)
    end

    def test_index_bad_json
      @repo.write_index!("")
      e = assert_raises(RBICentral::Index::Error) do
        @repo.index
      end
      assert_equal("Invalid JSON in `index.json`: unexpected token at ''", e.message)
    end

    def test_index_bad_schema
      @repo.write_index!(<<~JSON)
        {
          "foo": 42
        }
      JSON
      e = assert_raises(RBICentral::Index::Error) do
        @repo.index
      end
      assert_equal("The property `#/foo` of type integer did not match the following type: object", e.message)
    end

    def test_index_valid
      @repo.write_index!(<<~JSON)
        {
          "gem1": {},
          "gem2": {
            "requires": ["x"],
            "dependencies": ["a", "b"]
          }
        }
      JSON
      assert_equal(2, @repo.index.gems.size)
    end

    def test_annotations_files
      @repo.write_annotations_file!("gem1", "<some rbi>")
      @repo.write_annotations_file!("gem2", "<some rbi>")

      path = @repo.annotations_path
      assert_equal(["#{path}/gem1.rbi", "#{path}/gem2.rbi"], @repo.annotations_files)
    end

    def test_check_unexpected_annotations_files
      @repo.write!("#{@repo.annotations_path}/file1", "<rbi>")
      @repo.write!("#{@repo.annotations_path}/file2.rb", "<rbi>")
      @repo.write!("#{@repo.annotations_path}/file3.RBI", "<rbi>")
      @repo.write!("#{@repo.annotations_path}/dir/file4.rbi", "<rbi>")

      assert_messages(
        [
          "Unexpected RBI annotations file `rbi/annotations/dir/file4.rbi` (must be in `rbi/annotations` root directory)", # rubocop:disable Layout/LineLength
          "Unexpected RBI annotations file `rbi/annotations/file1` (should have `.rbi` extension)",
          "Unexpected RBI annotations file `rbi/annotations/file2.rb` (should have `.rbi` extension)",
          "Unexpected RBI annotations file `rbi/annotations/file3.RBI` (should have `.rbi` extension)",
        ],
        @repo.check_unexpected_annotations_files,
      )
    end

    def test_check_index_format
      @repo.write_index!(<<~JSON)
        {
          "gem1": {},
          "gem2": {
            "requires": ["x"],
            "dependencies": ["a", "b"]
          }
        }
      JSON

      assert_equal(<<~ERROR, @repo.check_index_format.first&.message)
        Formatting errors found in `index.json`:
        --- expected
        +++ index.json
        @@ -1,12 +1,7 @@
         {
           "gem1": {},
           "gem2": {
        -    "dependencies": [
        -      "a",
        -      "b"
        -    ],
        -    "requires": [
        -      "x"
        -    ]
        +    "requires": ["x"],
        +    "dependencies": ["a", "b"]
           }
         }
      ERROR
    end

    def test_check_missing_index_entries
      @repo.write_index!(<<~JSON)
        {
          "gem1": {}
        }
      JSON
      @repo.write_annotations_file!("gem1", "<rbi>")
      @repo.write_annotations_file!("gem2", "<rbi>")
      @repo.write_annotations_file!("gem3", "<rbi>")
      assert_messages(
        [
          "Missing index entry for `rbi/annotations/gem2.rbi` (key `gem2` not found in `index.json`)",
          "Missing index entry for `rbi/annotations/gem3.rbi` (key `gem3` not found in `index.json`)",
        ],
        @repo.check_missing_index_entries,
      )
    end

    def test_check_missing_annotations_files
      @repo.write_index!(<<~JSON)
        {
          "gem1": {},
          "gem2": {},
          "gem3": {}
        }
      JSON
      @repo.write_annotations_file!("gem1", "<rbi>")
      assert_messages(
        [
          "Missing RBI annotations file for `gem2` (file `rbi/annotations/gem2.rbi` not found)",
          "Missing RBI annotations file for `gem3` (file `rbi/annotations/gem3.rbi` not found)",
        ],
        @repo.check_missing_annotations_files,
      )
    end

    def test_check_rubocop_for_valid
      @repo.write_annotations_file!("gem1", <<~RBI)
        # typed: true

        module Spoom; end
      RBI
      assert_empty(@repo.check_rubocop_for(Gem.new(name: "gem1")))
    end

    def test_check_rubocop_for_invalid
      @repo.write_annotations_file!("gem1", <<~RBI)
        # typed: strict

        module Spoom; end
      RBI
      errors = @repo.check_rubocop_for(Gem.new(name: "gem1"))
      assert_equal(<<~ERR, errors.first&.message)
        rbi/annotations/gem1.rbi:1:1: C: Sorbet/ValidSigil: Sorbet sigil should be true got strict.
        # typed: strict
        ^^^^^^^^^^^^^^^
      ERR
    end

    def test_check_rubygems_for_valid
      assert_empty(@repo.check_rubygems_for(Gem.new(name: "rbi")))
    end

    def test_check_rubygems_for_invalid
      errors = @repo.check_rubygems_for(Gem.new(name: "a-non-existent-gem"))
      assert_equal(<<~ERR, errors.first&.message)
        `a-non-existent-gem` doesn't seem to be a public
           Make sure your gem is available at https://rubygems.org/gems/a-non-existent-gem
      ERR
    end

    def test_changed_files_not_git
      e = assert_raises(Repo::Error) do
        @repo.changed_files
      end
      assert_equal(
        "fatal: not a git repository (or any of the parent directories): .git",
        e.message.lines.first.strip,
      )
    end

    def test_changed_files_bad_ref
      @repo.git_init!
      e = assert_raises(Repo::Error) do
        @repo.changed_files(ref: "bad-ref")
      end
      assert_equal(
        "fatal: bad revision 'bad-ref'",
        e.message.lines.first.strip,
      )
    end

    def test_changed_files
      @repo.git_init!
      @repo.git_commit!
      assert_empty(@repo.changed_files)

      @repo.write_annotations_file!("foo", "<rbi>")
      @repo.write_index!("<json>")
      assert_equal(["index.json", "rbi/annotations/foo.rbi"], @repo.changed_files)

      @repo.git_commit!
      @repo.write_annotations_file!("foo", "<changed>")
      assert_equal(["rbi/annotations/foo.rbi"], @repo.changed_files)
    end

    def test_changed_files_since_ref
      @repo.git_init!
      @repo.git_commit!
      assert_empty(@repo.changed_files)

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write_annotations_file!("foo", "<rbi>")
      @repo.write_index!("<json>")
      @repo.git_commit!
      assert_equal(["index.json", "rbi/annotations/foo.rbi"], @repo.changed_files(ref: "main"))

      @repo.write_annotations_file!("bar", "<rbi>")
      @repo.write_annotations_file!("foo", "<changed>")
      assert_equal(
        ["index.json", "rbi/annotations/bar.rbi", "rbi/annotations/foo.rbi"],
        @repo.changed_files(ref: "main"),
      )
    end

    def test_changed_annotations
      @repo.git_init!
      @repo.write_annotations_file!("foo", "<rbi>")
      @repo.git_commit!
      assert_empty(@repo.changed_annotations)

      @repo.write!("Gemfile.lock", "")
      assert_empty(@repo.changed_annotations)
      @repo.git_commit!

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write_annotations_file!("bar", "<rbi>")
      @repo.write_annotations_file!("foo", "<update>")
      assert_equal(["bar", "foo"], @repo.changed_annotations)

      @repo.git_commit!
      assert_empty(@repo.changed_annotations)
      assert_equal(["bar", "foo"], @repo.changed_annotations(ref: "main"))

      @repo.remove!("rbi/annotations/foo.rbi")
      assert_empty(@repo.changed_annotations)
      assert_empty(@repo.changed_annotations(ref: "HEAD"))
    end

    def test_index_changed?
      @repo.git_init!
      @repo.write!("Gemfile.lock", "")
      @repo.git_commit!
      refute(@repo.index_changed?)

      @repo.write_index!("<json>")
      assert(@repo.index_changed?)

      @repo.git_commit!
      refute(@repo.index_changed?)

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write_index!("<update>")
      assert(@repo.index_changed?)

      @repo.git_commit!
      refute(@repo.index_changed?)
      assert(@repo.index_changed?(ref: "main"))
    end

    def test_load_index_ref
      @repo.git_init!
      @repo.git_commit!

      assert_raises(Index::Error) do
        @repo.load_index
      end

      @repo.write_index!("{ \"foo\": {} }")
      assert(@repo.load_index.gem?("foo"))

      @repo.git_commit!
      assert(@repo.load_index(ref: "HEAD").gem?("foo"))

      @repo.write_index!("{}")
      refute(@repo.load_index.gem?("foo"))
      assert(@repo.load_index(ref: "HEAD").gem?("foo"))
    end

    def test_index_changes
      @repo.git_init!
      @repo.git_commit!
      assert_nil(@repo.index_changes)

      @repo.write_index!("{ \"gem1\": {} }")
      @repo.git_commit!
      assert_nil(@repo.index_changes)

      @repo.write_index!("{ \"gem1\": {   } }")
      assert_empty(@repo.index_changes)

      @repo.write_index!("{ \"gem2\": {} }")
      changes = @repo.index_changes
      assert_equal(["gem1"], changes&.removed&.map(&:name))
      assert_equal(["gem2"], changes&.added&.map(&:name))

      @repo.write_index!("{ \"gem2\": {} }")
      @repo.git_commit!
      changes = @repo.index_changes(ref: "HEAD~1")
      assert_equal(["gem1"], changes&.removed&.map(&:name))
      assert_equal(["gem2"], changes&.added&.map(&:name))
    end
  end
end
