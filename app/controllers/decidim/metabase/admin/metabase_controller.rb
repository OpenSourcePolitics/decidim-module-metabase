# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class MetabaseController < Decidim::Metabase::Admin::ApplicationController
        before_action :authorized?
        helper_method :urls, :metabase_enabled?

        private

        def authorized?
          enforce_permission_to :read, :metabase
        end

        def urls
          @urls ||= MetabaseService.urls
        end

        def metabase_enabled?
          Rails.application.secrets.try(:metabase)&.fetch(:enabled, false)
        end
      end
    end
  end
end
