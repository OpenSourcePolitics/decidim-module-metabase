# frozen_string_literal: true

module Decidim
  # This holds the decidim-metabase version.
  module Metabase
    def self.version
      "0.0.1"
    end

    def self.decidim_version
      "~>0.25"
    end

    def self.decidim_branch
      "release/0.25-stable"
    end
  end
end
