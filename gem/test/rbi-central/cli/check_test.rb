# typed: true
# frozen_string_literal: true

require "test_helper"

module RBICentral
  module CLI
    class CheckTest < TestWithRepo
      def test_check_all_valid
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{@repo.add_mock_gem("gem1").absolute_path}"
            },
            "gem2": {
              "path": "#{@repo.add_mock_gem("gem2").absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          # typed: strict

          module Gem1
            abstract!
          end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: strict

          module Gem2
            abstract!
          end
        RBI
        res = @repo.repo("check --no-gem --no-static --all")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          The following checks will run:
            `index`    checks the index validity
            `rubocop`  checks the RBI files against RuboCop
            `rubygems` checks the RBI files against Rubygems
            `runtime`  checks the RBI files against runtime execution

          ### Checking index...

          No errors, good job!

          ### Linting RBI files...

          Linting `gem1`...
          Linting `gem2`...

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem1`...
          Checking Rubygems for `gem2`...

          No errors, good job!

          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...
          Checking runtime for `gem2`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_check_all_invalid
        gem1 = @repo.add_mock_gem("gem1")
        gem2 = @repo.add_mock_gem("gem2")
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            },
            "gem2": { "path": "#{gem2.absolute_path}" }
          }
        JSON
        @repo.write_annotations_file!("gem1", <<~RBI)
          class Gem1::NotFound; end
        RBI
        @repo.write_annotations_file!("gem2", <<~RBI)
          # typed: strict

          module Gem2
            abstract!
          end
        RBI
        res = @repo.repo("check --no-gem --no-static --all")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          The following checks will run:
            `index`    checks the index validity
            `rubocop`  checks the RBI files against RuboCop
            `rubygems` checks the RBI files against Rubygems
            `runtime`  checks the RBI files against runtime execution

          ### Checking index...

          Error: Formatting errors found in `index.json`:
          --- expected
          +++ index.json
          @@ -2,7 +2,5 @@
             "gem1": {
               "path": "#{gem1.absolute_path}"
             },
          -  "gem2": {
          -    "path": "#{gem2.absolute_path}"
          -  }
          +  "gem2": { "path": "#{gem2.absolute_path}" }
           }

          ### Linting RBI files...

          Linting `gem1`...

          Error: rbi/annotations/gem1.rbi:1:1: C: [Correctable] Sorbet/StrictSigil: No Sorbet sigil found in file. Try a typed: strict to start (you can also use rubocop -a to automatically add this).
          class Gem1::NotFound; end
          ^^^^^
          rbi/annotations/gem1.rbi:1:1: C: [Correctable] Sorbet/ValidSigil: No Sorbet sigil found in file. Try a typed: true to start (you can also use rubocop -a to automatically add this).
          class Gem1::NotFound; end
          ^^^^^

          Linting `gem2`...

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem1`...
          Checking Rubygems for `gem2`...

          No errors, good job!

          ### Checking RBI files against runtime execution...

          Checking runtime for `gem1`...

          Error: Missing runtime constant `::Gem1::NotFound` (defined at `rbi/annotations/gem1.rbi:1:0-1:25`)

          Checking runtime for `gem2`...

          Some checks failed. See above for details.
        ERR
        refute(res.status)
      end

      def test_check_no_changes
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{@repo.add_mock_gem("gem1").absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.bundle_install!
        @repo.git_init!
        @repo.git_commit!
        res = @repo.repo("check")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          No change detected. Run with `--all` to run all checks.
        ERR
        assert(res.status)
      end

      def test_check_no_relevant_changes
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{@repo.add_mock_gem("gem1").absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.bundle_install!
        @repo.git_init!
        @repo.git_commit!
        @repo.write!("some_other_file.rb", "")
        res = @repo.repo("check")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * some_other_file.rb

          No change detected. Run with `--all` to run all checks.
        ERR
        assert(res.status)
      end

      def test_check_index_modified
        @repo.git_init!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.git_commit!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
            },
            "gem2": {
            }
          }
        JSON
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * index.json

          The following checks will run:
            `index`    checks the index validity
            `rubygems` checks the RBI files against Rubygems

          ### Checking index...

          Error: Missing RBI annotations file for `gem2` (file `rbi/annotations/gem2.rbi` not found)

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem2`...

          No errors, good job!

          Some checks failed. See above for details.
        ERR
        refute(res.status)
        @repo.write_index!(<<~JSON)
          {
          }
        JSON
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * index.json

          The following checks will run:
            `index`    checks the index validity

          ### Checking index...

          Error: Missing index entry for `rbi/annotations/gem1.rbi` (key `gem1` not found in `index.json`)

          Some checks failed. See above for details.
        ERR
        refute(res.status)
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "requires": [
                "gem2"
              ]
            }
          }
        JSON
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * index.json

          The following checks will run:
            `index`    checks the index validity
            `rubygems` checks the RBI files against Rubygems

          ### Checking index...

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem1`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_check_annotations_added
        gem1 = @repo.add_mock_gem("gem1")
        gem2 = @repo.add_mock_gem("gem2")
        @repo.bundle_install!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Gem1; end")
        @repo.git_init!
        @repo.git_commit!

        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            },
            "gem2": {
              "path": "#{gem2.absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem2", "module Gem2; end")
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * index.json
           * rbi/annotations/gem2.rbi

          The following checks will run:
            `index`    checks the index validity
            `rubygems` checks the RBI files against Rubygems

          ### Checking index...

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem2`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_check_annotations_modified
        gem1 = @repo.add_mock_gem("gem1")
        gem2 = @repo.add_mock_gem("gem2")
        @repo.bundle_install!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            },
            "gem2": {
              "path": "#{gem2.absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.git_init!
        @repo.git_commit!
        @repo.write_annotations_file!("gem2", "module Foo; end")
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * rbi/annotations/gem2.rbi

          The following checks will run:
            `rubygems` checks the RBI files against Rubygems

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem2`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_check_annotations_removed
        @repo.bundle_install!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {}
          }
        JSON
        @repo.write_annotations_file!("gem1", "<rbi>")
        @repo.git_init!
        @repo.git_commit!
        @repo.remove!("rbi/annotations/gem1.rbi")
        res = @repo.repo("check --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          No change detected. Run with `--all` to run all checks.
        ERR
        assert(res.status)
      end

      def test_check_gemfile_modified
        gem1 = @repo.add_mock_gem("gem1")
        gem2 = @repo.add_mock_gem("gem2")
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            },
            "gem2": {
              "path": "#{gem2.absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Foo; end")
        @repo.write_annotations_file!("gem2", "module Foo; end")
        @repo.git_init!
        @repo.git_commit!
        @repo.write_gemfile!("\n", append: true)
        res = @repo.repo("check --no-gem --no-rubocop --no-runtime --no-static")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * Gemfile
           * Gemfile.lock

          The following checks will run:
            `index`    checks the index validity
            `rubygems` checks the RBI files against Rubygems

          ### Checking index...

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem1`...
          Checking Rubygems for `gem2`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end

      def test_check_gem_modified
        gem1 = @repo.add_mock_gem("gem1")
        gem2 = @repo.add_mock_gem("gem2")
        @repo.bundle_install!
        @repo.write_index!(<<~JSON)
          {
            "gem1": {
              "path": "#{gem1.absolute_path}"
            },
            "gem2": {
              "path": "#{gem2.absolute_path}"
            }
          }
        JSON
        @repo.write_annotations_file!("gem1", "module Foo; end")
        @repo.write_annotations_file!("gem2", "module Foo; end")
        @repo.git_init!
        @repo.git_commit!
        @repo.write!("gem/bin/typecheck", <<~RB)
          #!/usr/bin/env ruby
          $stderr.puts "Sorbet OK"
          exit(0)
        RB
        @repo.exec("chmod +x gem/bin/typecheck")
        @repo.write!("gem/bin/style", <<~RB)
          #!/usr/bin/env ruby
          $stderr.puts "Rubocop OK"
          exit(0)
        RB
        @repo.exec("chmod +x gem/bin/style")
        @repo.write!("gem/bin/test", <<~RB)
          #!/usr/bin/env ruby
          $stderr.puts "Tests OK"
          exit(0)
        RB
        @repo.exec("chmod +x gem/bin/test")
        res = @repo.repo("check --no-rubocop --no-runtime --no-static --gem")
        assert_equal(<<~ERR, RBICentral.filter_parser_warning(T.must(res.err)))
          ### Checking changed files...

          Changed files:

           * gem/bin/style
           * gem/bin/test
           * gem/bin/typecheck

          The following checks will run:
            `gem`      runs the test units of the embedded gem
            `index`    checks the index validity
            `rubygems` checks the RBI files against Rubygems

          ### Checking gem...

          Installing gem dependencies...

          Running Sorbet on gem...

          Sorbet OK

          Running Rubocop on gem...

          Rubocop OK

          Running gem tests...

          Tests OK


          ### Checking index...

          No errors, good job!

          ### Checking that RBI files belong to public gems...

          Checking Rubygems for `gem1`...
          Checking Rubygems for `gem2`...

          No errors, good job!

          All checks passed without error, good job!
        ERR
        assert(res.status)
      end
    end
  end
end
