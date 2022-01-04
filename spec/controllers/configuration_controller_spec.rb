# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe ConfigurationsController, type: :controller do
        routes { Decidim::Metabase::AdminEngine.routes }

        let(:organization) { create :organization }
        let(:current_user) { create(:user, :admin, :confirmed, organization: organization) }

        let(:params) do
          {
            login: "dummy",
            password: "dummy",
            dashboard_ids: "1, 2, 3, 4"
          }
        end

        before do
          request.env["decidim.current_organization"] = organization
          sign_in current_user, scope: :user
        end

        describe "GET #edit" do
          it "renders a form" do
            get :edit

            expect(response).to render_template(:edit)
          end
        end

        describe "POST #update" do
          it "redirects to the index page a flash message" do
            post :update, params: params

            expect(flash[:notice]).to be_present
            expect(response).to have_http_status(:redirect)
          end
        end
      end
    end
  end
end
