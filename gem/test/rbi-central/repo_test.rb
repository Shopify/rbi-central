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
      @repo.write!(@repo.index_path, "")
      e = assert_raises(RBICentral::Index::Error) do
        @repo.index
      end
      assert_equal("Invalid JSON in `index.json`: unexpected token at ''", e.message)
    end

    def test_index_bad_schema
      @repo.write!(@repo.index_path, <<~JSON)
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
      @repo.write!(@repo.index_path, <<~JSON)
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
      path = @repo.annotations_path
      @repo.write!("#{path}/gem1.rbi", "<some rbi>")
      @repo.write!("#{path}/gem2.rbi", "<some rbi>")
      assert_equal(["#{path}/gem1.rbi", "#{path}/gem2.rbi"], @repo.annotations_files)
    end

    def test_check_index_format
      @repo.write!(@repo.index_path, <<~JSON)
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
        @@ -1,13 +1,7 @@
         {
        -  "gem1": {
        -  },
        +  "gem1": {},
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
      @repo.write!(@repo.index_path, <<~JSON)
        {
          "gem1": {}
        }
      JSON
      path = @repo.annotations_path
      @repo.write!("#{path}/gem1.rbi", "<rbi>")
      @repo.write!("#{path}/gem2.rbi", "<rbi>")
      @repo.write!("#{path}/gem3.rbi", "<rbi>")
      assert_messages([
        "Missing index entry for `rbi/annotations/gem2.rbi` (key `gem2` not found in `index.json`)",
        "Missing index entry for `rbi/annotations/gem3.rbi` (key `gem3` not found in `index.json`)",
      ], @repo.check_missing_index_entries)
    end

    def test_check_missing_annotations_files
      @repo.write!(@repo.index_path, <<~JSON)
        {
          "gem1": {},
          "gem2": {},
          "gem3": {}
        }
      JSON
      @repo.write!("#{@repo.annotations_path}/gem1.rbi", "<rbi>")
      assert_messages([
        "Missing RBI annotations file for `gem2` (file `rbi/annotations/gem2.rbi` not found)",
        "Missing RBI annotations file for `gem3` (file `rbi/annotations/gem3.rbi` not found)",
      ], @repo.check_missing_annotations_files)
    end

    def test_check_rubocop_for_valid
      @repo.write!("#{@repo.annotations_path}/gem1.rbi", <<~RBI)
        # typed: strict

        module Spoom; end
      RBI
      assert_empty(@repo.check_rubocop_for(Gem.new(name: "gem1")))
    end

    def test_check_rubocop_for_invalid
      @repo.write!("#{@repo.annotations_path}/gem1.rbi", <<~RBI)
        # typed: true

        module Spoom; end
      RBI
      errors = @repo.check_rubocop_for(Gem.new(name: "gem1"))
      assert_equal(<<~ERR, errors.first&.message)
        rbi/annotations/gem1.rbi:1:1: C: Sorbet/StrictSigil: Sorbet sigil should be at least strict got true.
        # typed: true
        ^^^^^^^^^^^^^
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
        e.message.lines.first.strip
      )
    end

    def test_changed_files_bad_ref
      @repo.git_init!
      e = assert_raises(Repo::Error) do
        @repo.changed_files(ref: "bad-ref")
      end
      assert_equal(
        "fatal: bad revision 'bad-ref'",
        e.message.lines.first.strip
      )
    end

    def test_changed_files
      @repo.git_init!
      @repo.git_commit!
      assert_empty(@repo.changed_files)

      @repo.write!("annotations/foo.rbi", "<rbi>")
      @repo.write!("index.json", "<rbi>")
      assert_equal(["annotations/foo.rbi", "index.json"], @repo.changed_files)

      @repo.git_commit!
      @repo.write!("annotations/foo.rbi", "<changed>")
      assert_equal(["annotations/foo.rbi"], @repo.changed_files)
    end

    def test_changed_files_since_ref
      @repo.git_init!
      @repo.git_commit!
      assert_empty(@repo.changed_files)

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write!("annotations/foo.rbi", "<rbi>")
      @repo.write!("index.json", "<json>")
      @repo.git_commit!
      assert_equal(["annotations/foo.rbi", "index.json"], @repo.changed_files(ref: "main"))

      @repo.write!("annotations/bar.rbi", "<rbi>")
      @repo.write!("annotations/foo.rbi", "<changed>")
      assert_equal(["annotations/bar.rbi", "annotations/foo.rbi", "index.json"], @repo.changed_files(ref: "main"))
    end

    def test_changed_anontations
      @repo.git_init!
      @repo.write!("rbi/annotations/foo.rbi", "<rbi>")
      @repo.git_commit!
      assert_empty(@repo.changed_annotations)

      @repo.write!("Gemfile.lock", "")
      assert_empty(@repo.changed_annotations)
      @repo.git_commit!

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write!("rbi/annotations/bar.rbi", "<rbi>")
      @repo.write!("rbi/annotations/foo.rbi", "<update>")
      assert_equal(["bar", "foo"], @repo.changed_annotations)

      @repo.git_commit!
      assert_empty(@repo.changed_annotations)
      assert_equal(["bar", "foo"], @repo.changed_annotations(ref: "main"))
    end

    def test_index_changed?
      @repo.git_init!
      @repo.write!("Gemfile.lock", "")
      @repo.git_commit!
      refute(@repo.index_changed?)

      @repo.write!("index.json", "<json>")
      assert(@repo.index_changed?)

      @repo.git_commit!
      refute(@repo.index_changed?)

      @repo.git_create_and_checkout_branch!("branch")
      @repo.write!("index.json", "<update>")
      assert(@repo.index_changed?)

      @repo.git_commit!
      refute(@repo.index_changed?)
      assert(@repo.index_changed?(ref: "main"))
    end

    private

    sig { params(messages: T::Array[String], errors: T::Array[Error]).void }
    def assert_messages(messages, errors)
      assert_equal(messages, errors.map(&:message))
    end
  end
end
