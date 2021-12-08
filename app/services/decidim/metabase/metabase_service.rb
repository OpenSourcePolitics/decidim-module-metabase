# frozen_string_literal: true

require "jwt"

module Decidim
  module Metabase
    class MetabaseService
      # Returns array of urls from Metabase Iframe
      def self.urls
        return if metabase_dashboard_ids.blank?

        metabase_dashboard_ids.map do |id|
          run(id)
        end
      end

      def self.run(dashboard_id)
        new(dashboard_id).url
      end

      # JWT expiration time as minutes
      def self.expiration_minutes
        10
      end

      def self.metabase_site_url
        metabase_secrets&.fetch(:site_url, nil)
      end

      def self.metabase_secret_key
        metabase_secrets&.fetch(:secret_key, nil)
      end

      def self.metabase_dashboard_ids
        metabase_secrets&.fetch(:dashboard_ids, []) || []
      end

      def self.metabase_secrets
        Rails.application.secrets.try(:metabase)
      end

      def initialize(dashboard_id)
        @dashboard_id = dashboard_id
      end

      # Metabase Iframe url
      def url
        "#{self.class.send(:metabase_site_url)}/embed/dashboard/#{token}#bordered=true&titled=true"
      end

      private_class_method :metabase_secret_key, :metabase_dashboard_ids, :metabase_secrets

      private

      def token
        JWT.encode payload, self.class.send(:metabase_secret_key)
      end

      def payload
        {
          resource: { dashboard: @dashboard_id },
          params: {},
          exp: Time.now.to_i + (60 * MetabaseService.expiration_minutes) # 10 minute expiration
        }
      end
    end
  end
end
