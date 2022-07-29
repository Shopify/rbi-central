# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rbi-central/version"

Gem::Specification.new do |spec|
  spec.name          = "rbi-central"
  spec.version       = RBICentral::VERSION
  spec.authors       = ["Alexandre Terrasa"]
  spec.email         = ["ruby@shopify.com"]

  spec.summary       = "A CLI tool to manage RBI repositories"
  spec.homepage      = "https://github.com/Shopify/rbi-central"
  spec.license       = "MIT"

  spec.bindir        = "exe"
  spec.executables   = ["check_all", "check_gems_are_public", "check_index", "check_runtime", "check_static", "run_on_changed_rbis"]
  spec.require_paths = ["lib"]

  spec.files         = Dir.glob("lib/**/*.rb") + ["README.md", "Gemfile"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.add_dependency("json-schema", ">= 3.0.0")
  spec.add_dependency("rbi", ">= 0.0.15")
  spec.add_dependency("rubocop", ">= 1.29.1")
  spec.add_dependency("rubocop-shopify", ">= 2.5.0")
  spec.add_dependency("rubocop-sorbet", ">= 0.6.11")
  spec.add_dependency("spoom", ">= 1.1.11")
  spec.add_dependency("sorbet-static-and-runtime", ">= 0.5.10225")
  spec.add_dependency("tapioca", ">= 0.9.2")
  spec.add_dependency("thor", ">= 1.2.1")

  spec.required_ruby_version = ">= 2.7"
end
