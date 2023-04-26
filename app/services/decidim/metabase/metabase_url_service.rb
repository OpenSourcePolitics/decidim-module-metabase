# frozen_string_literal: true

require "jwt"

module Decidim
  module Metabase
    class MetabaseUrlService
      include Decidim::Metabase::MetabaseCredentials

      def initialize(dashboard_id)
        @dashboard_id = dashboard_id
        @expiration_minutes = 10
      end

      def self.run(dashboard_id)
        new(dashboard_id).url
      end

      # Metabase Iframe url
      def url
        "#{Decidim::Metabase::MetabaseCredentials.metabase_site_url}/embed/dashboard/#{token}#bordered=true&titled=true"
      end

      private

      def token
        JWT.encode payload, Decidim::Metabase::MetabaseCredentials.metabase_secret_key
      end

      def payload
        {
          resource: { dashboard: @dashboard_id },
          params: {},
          exp: Time.now.to_i + (60 * @expiration_minutes) # 10 minute expiration
        }
      end
    end
  end
end
