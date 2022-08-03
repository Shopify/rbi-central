# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

require "json-schema"
require "net/http"
require "open3"
require "rbi"
require "thor"
require "tmpdir"
require "spoom"

module RBICentral
  INDEX_PATH = "index.json"
  SCHEMA_PATH = "schema.json"
  ANNOTATIONS_PATH = "rbi/annotations"
  RUBOCOP_CONFIG_PATH = ".rubocop.yml"
end

require "rbi-central/version"
require "rbi-central/cli/helper"
require "rbi-central/index_validator"
require "rbi-central/context"
require "rbi-central/static/context"
require "rbi-central/runtime/visitor"
require "rbi-central/runtime/context"
