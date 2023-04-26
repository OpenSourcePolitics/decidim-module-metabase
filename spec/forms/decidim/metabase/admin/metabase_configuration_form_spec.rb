# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe MetabaseConfigurationForm do
        subject do
          described_class.from_params(
            metabase_configuration: {
              login: login,
              password: password,
              dashboard_ids: dashboard_ids
            }
          )
        end

        let(:login) { "login" }
        let(:password) { "password" }
        let(:dashboard_ids) { "1, 2, 3, 4" }
        let(:organization) { create(:organization, :with_metabase_configuration) }

        it { is_expected.to be_valid }

        context "when login is nil" do
          let(:login) { nil }

          it { is_expected.to be_valid }
        end

        context "when password is nil" do
          let(:password) { nil }

          it { is_expected.to be_valid }
        end

        describe "dashboard_ids" do
          context "when dashboard_ids is nil" do
            let(:dashboard_ids) { nil }

            it { is_expected.to be_valid }
          end

          context "when dashboard_ids includes letters" do
            let(:dashboard_ids) { "1, 2, A, 4" }

            it { is_expected.to be_invalid }
          end

          context "when dashboard_ids includes a blank space" do
            let(:dashboard_ids) { "1, 2, 3,  4" }

            it { is_expected.to be_valid }
          end

          context "when dashboard_ids includes special character" do
            let(:dashboard_ids) { "1, 2, &, 4" }

            it { is_expected.to be_invalid }
          end

          context "when dashboard_ids includes one value" do
            let(:dashboard_ids) { "1" }

            it { is_expected.to be_valid }
          end
        end
      end
    end
  end
end
