# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    describe MetabaseService do
      subject { described_class }

      let(:enabled) { true }
      let(:metabase_site_url) { "fake_site_url" }
      let(:metabase_secret_key) { "fake_secret_key" }
      let(:metabase_dashboard_ids) { [1, 2, 3, 4] }
      let(:metabase_secrets) do
        {
          enabled: enabled,
          site_url: metabase_site_url,
          secret_key: metabase_secret_key,
          dashboard_ids: metabase_dashboard_ids
        }
      end

      before do
        allow(Rails.application.secrets).to receive(:metabase).and_return(metabase_secrets)
      end

      describe "#metabase_secrets" do
        it "returns metabase rails application secrets" do
          expect(subject.send(:metabase_secrets)).to eq(metabase_secrets)
        end

        context "when metabase secrets are not defined" do
          let(:metabase_secrets) { nil }

          it "returns nil" do
            expect(subject.send(:metabase_secrets)).to be_nil
          end
        end
      end

      describe "#metabase_site_url" do
        it "returns metabase site url" do
          expect(subject.send(:metabase_site_url)).to eq(metabase_site_url)
        end

        context "when metabase site url is not defined" do
          let(:metabase_site_url) { nil }

          it "returns nil" do
            expect(subject.send(:metabase_site_url)).to be_nil
          end
        end

        context "when metabase site url is not present in secrets" do
          let(:metabase_secrets) { {} }

          it "returns nil" do
            expect(subject.send(:metabase_site_url)).to be_nil
          end
        end
      end

      describe "#metabase_secret_key" do
        it "returns metabase secret key" do
          expect(subject.send(:metabase_secret_key)).to eq(metabase_secret_key)
        end

        context "when there is no metabase secret key" do
          let(:metabase_secret_key) { nil }

          it "returns nil" do
            expect(subject.send(:metabase_secret_key)).to be_nil
          end
        end
      end

      describe "#metabase_dashboard_ids" do
        it "returns metabase dashboard IDs as array" do
          expect(subject.send(:metabase_dashboard_ids)).to eq(metabase_dashboard_ids)
        end

        context "when there is no metabase dashboard ID" do
          let(:metabase_dashboard_ids) { nil }

          it "returns empty array" do
            expect(subject.send(:metabase_dashboard_ids)).to be_a(Array)
            expect(subject.send(:metabase_dashboard_ids)).to eq([])
          end
        end
      end
    end
  end
end
