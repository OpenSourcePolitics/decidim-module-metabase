# frozen_string_literal: true

module Decidim
  module Analytics
    module Admin
      class AnalyticsController < Analytics::Admin::ApplicationController

        def index
          @site_url = Rails.application.secrets.dig(:metabase, :site_url)
          @dashboard_id =  Rails.application.secrets.dig(:metabase, :dashboard_id)
          @secret_key =  Rails.application.secrets.dig(:metabase, :secret_key)

          payload = {
            :resource => {:dashboard => @dashboard_id},
            :params => {
              
            },
            :exp => Time.now.to_i + (60 * 10) # 10 minute expiration
          }

          token = JWT.encode payload, @secret_key

          @iframe_url = @site_url + "/embed/dashboard/" + token + "#bordered=true&titled=true"
        end
      end
    end
  end
end
