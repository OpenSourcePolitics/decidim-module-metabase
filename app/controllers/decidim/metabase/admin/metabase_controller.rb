# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class MetabaseController < Decidim::Metabase::Admin::ApplicationController
        helper_method :urls, :metabase_enabled?

        private

        def urls
          @urls ||= MetabaseService.urls_for(current_organization)
        end

        def metabase_enabled?
          Decidim::Metabase::MetabaseCredentials.metabase_enabled?
        end
      end
    end
  end
end
