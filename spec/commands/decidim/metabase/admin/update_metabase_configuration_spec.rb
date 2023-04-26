# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe UpdateMetabaseConfiguration do
        subject { described_class.new(organization, form) }

        let(:login) { "login" }
        let(:password) { "password" }
        let(:dashboard_ids) { "1, 2, 3, 4" }
        let(:organization) { create(:organization) }
        let(:form) do
          double(
            invalid?: invalid,
            login: login,
            password: password,
            dashboard_ids: dashboard_ids
          )
        end
        let(:invalid) { false }

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          it "stores the configuration" do
            subject.call

            configuration = organization.reload.metabase_configuration

            expect(configuration["login"]).to eq("login")
            expect(configuration["dashboard_ids"]).to eq([1, 2, 3, 4])
            expect(configuration["password"]).to eq("password")
          end

          context "when the dashboard_ids contains blank spaces" do
            let(:dashboard_ids) { "12, 22, 32,  4" }

            it "stores the configuration" do
              subject.call
              configuration = organization.reload.metabase_configuration

              expect(configuration["login"]).to eq("login")
              expect(configuration["dashboard_ids"]).to eq([12, 22, 32, 4])
              expect(configuration["password"]).to eq("password")
            end
          end
        end
      end
    end
  end
end
