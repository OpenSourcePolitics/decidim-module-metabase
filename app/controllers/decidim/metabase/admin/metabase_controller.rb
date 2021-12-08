# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class MetabaseController < ApplicationController
        before_action :authorized?

        private

        def authorized?
          enforce_permission_to :read, :metabase
        end
      end
    end
  end
end
