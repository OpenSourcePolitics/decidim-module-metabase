# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/metabase/version"

Gem::Specification.new do |s|
  s.version = Decidim::Metabase.version
  s.authors = ["quentinchampenois"]
  s.email = ["26109239+Quentinchampenois@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-metabase"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-metabase"
  s.summary = "A decidim metabase module"
  s.description = "Display your Metabase dashboards directly in Decidim's administration area."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Metabase.decidim_version
end
