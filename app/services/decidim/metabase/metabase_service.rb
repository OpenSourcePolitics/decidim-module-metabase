# frozen_string_literal: true

require "jwt"

module Decidim
  module Metabase
    class MetabaseService
      def initialize(organization)
        @organization = organization
      end

      def self.urls_for(organization)
        new(organization).run
      end

      def run
        return unless Decidim::Metabase::MetabaseCredentials.metabase_enabled?
        return if allowed_dashboard_ids.blank?

        allowed_dashboard_ids.map do |dashboard_id|
          Decidim::Metabase::MetabaseUrlService.new(dashboard_id).url
        end
      end

      private

      def allowed_dashboard_ids
        return if metabase_dashboard_ids.blank?

        metabase_dashboard_ids.select { |id| allowed_collections.include? id }
      end

      def allowed_collections
        Rails.cache.fetch("#{@organization.cache_key_with_version}/allowed_collections", expires_in: 15.minutes) do
          Decidim::Metabase::MetabaseApiWrapper.collections(metabase_login, metabase_password)
        end
      end

      def metabase_dashboard_ids
        metabase_configuration&.fetch(:dashboard_ids, nil)
      end

      def metabase_login
        metabase_configuration&.deep_symbolize_keys&.fetch(:login, nil)
      end

      def metabase_password
        metabase_configuration&.fetch(:password, nil)
      end

      def metabase_configuration
        @organization.metabase_configuration&.deep_symbolize_keys
      end
    end
  end
end
