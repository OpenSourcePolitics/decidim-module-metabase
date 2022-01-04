# frozen_string_literal: true

module Decidim
  module Metabase
    module MetabaseCredentials
      def self.metabase_site_url
        Rails.application.secrets.dig(:metabase, :site_url)
      end

      def self.metabase_secret_key
        Rails.application.secrets.dig(:metabase, :secret_key)
      end

      def self.metabase_enabled?
        Rails.application.secrets.dig(:metabase, :enabled)
      end
    end
  end
end
