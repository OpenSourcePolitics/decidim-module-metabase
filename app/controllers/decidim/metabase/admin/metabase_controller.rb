# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class MetabaseController < ApplicationController
        before_action :authorized?
        helper_method :urls

        private

        def authorized?
          enforce_permission_to :read, :metabase
        end

        def urls
          @urls ||= MetabaseService.urls
        end
      end
    end
  end
end
