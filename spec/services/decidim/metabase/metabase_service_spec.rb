# frozen_string_literal: true

require "spec_helper"

describe Decidim::Metabase::MetabaseService do
  subject { described_class.new(organization) }

  let(:organization) { create(:organization, metabase_configuration: metabase_configuration) }
  let(:metabase_configuration) do
    {
      login: "login",
      password: "password",
      dashboard_ids: dashboard_ids
    }
  end
  let(:dashboard_ids) { [1, 2, 3, 4] }
  let(:enabled) { true }
  let(:site_url) { "https://fake_site_url" }
  let(:secret_key) { "fake_secret_key" }
  let(:allowed_collections) { [1, 2, 3, 4] }

  before do
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_enabled?).and_return(enabled)
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_site_url).and_return(site_url)
    allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_secret_key).and_return(secret_key)
    allow(Decidim::Metabase::MetabaseApiWrapper).to receive(:collections).and_return(allowed_collections)
  end

  describe "#run" do
    let(:dashboard_ids) { [1] }

    before do
      allow(Decidim::Metabase::MetabaseUrlService.new(1)).to receive(:url).and_return("https://dummy.url")
    end

    context "when dashboard ids is blank" do
      let(:dashboard_ids) { nil }

      it "does nothing" do
        expect(subject.run).to eq(nil)
      end
    end

    context "when enabled is false" do
      let(:enabled) { nil }

      it "does nothing" do
        expect(subject.run).to eq(nil)
      end
    end

    it "returns an array of urls" do
      expect(subject.run).not_to eq(nil)
    end
  end

  describe "#metabase_dashboard_ids" do
    it "returns an array of dashboard ids" do
      expect(subject.send(:metabase_dashboard_ids)).to eq(dashboard_ids)
    end

    context "when configuration is nil" do
      let(:metabase_configuration) { nil }

      it "returns nil" do
        expect(subject.send(:metabase_dashboard_ids)).to eq(nil)
      end
    end
  end
end
