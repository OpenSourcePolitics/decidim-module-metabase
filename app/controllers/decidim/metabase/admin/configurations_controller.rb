# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class ConfigurationsController < Decidim::Metabase::Admin::ApplicationController
        def edit
          @form = form(Decidim::Metabase::Admin::MetabaseConfigurationForm).from_model(current_organization)
        end

        def update
          @form = form(Decidim::Metabase::Admin::MetabaseConfigurationForm).from_params(params)

          Decidim::Metabase::Admin::UpdateMetabaseConfiguration.call(current_organization, @form) do
            on(:ok) do
              flash[:notice] = I18n.t(".success", scope: "decidim.admin.metabase")
              redirect_to root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t(".error", scope: "decidim.admin.metabase")
              render :edit
            end
          end
        end
      end
    end
  end
end
