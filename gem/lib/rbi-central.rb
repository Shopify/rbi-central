# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

require "json-schema"
require "net/http"
require "open3"
require "rbi"
require "spoom"
require "tempfile"
require "tmpdir"
require "spoom"

module RBICentral
  extend T::Sig

  INDEX_PATH = "index.json"
  ANNOTATIONS_PATH = "rbi/annotations"

  INDEX_SCHEMA = T.let({
    "type": "object",
    "patternProperties": {
      "^.*$": {
        "type": "object",
        "properties": {
          "dependencies": {
            "description": "List of other gems that need to be installed to test the RBI contents",
            "type": "array",
            "items": {
              "type": "string",
              "uniqueItems": true,
            },
          },
          "requires": {
            "description": "List of files to require to test the RBI contents",
            "type": "array",
            "items": {
              "type": "string",
              "uniqueItems": true,
            },
          },
          "path": {
            "description": "(Optional) Path where this gem can be installed from",
            "type": "string",
          },
          "source": {
            "description": "(Optional) Source where this gem can be installed from",
            "type": "string",
          },
        },
        "additionalProperties": false,
      },
    },
  }, T::Hash[String, T.untyped])

  RUBOCOP_CONFIG = <<~YML
    inherit_gem:
      rubocop-sorbet: config/rbi.yml

    AllCops:
      TargetRubyVersion: 3.0
      NewCops: disable
      SuggestExtensions: false
      Include:
      - 'rbi/**/*'

    Sorbet/StrictSigil:
      Enabled: true
  YML

  class Error < StandardError; end

  sig { params(string: String).returns(String) }
  def self.filter_parser_warning(string)
    string
      .gsub(/warning:.*\n/, "")
      .gsub(/Please.*\n/, "")
  end
end

require "rbi-central/version"

require "rbi-central/gem"
require "rbi-central/index"
require "rbi-central/repo"

require "rbi-central/context"
require "rbi-central/static/context"
require "rbi-central/runtime/visitor"
require "rbi-central/runtime/context"
