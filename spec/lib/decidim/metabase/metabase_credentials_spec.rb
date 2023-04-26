# frozen_string_literal: true

require "spec_helper"

describe Decidim::Metabase::MetabaseCredentials do
  subject { described_class }

  let(:enabled) { true }
  let(:site_url) { "fake_site_url" }
  let(:secret_key) { "fake_secret_key" }

  describe ".secret_key" do
    before do
      allow(Rails.application.secrets).to receive(:dig).with(:metabase, :secret_key).and_return(secret_key)
    end

    it "returns secret_key" do
      expect(subject.metabase_secret_key).to eq(secret_key)
    end

    context "when secret_key is not defined" do
      let(:secret_key) { nil }

      it "returns nil" do
        expect(subject.metabase_secret_key).to be_nil
      end
    end
  end

  describe ".site_url" do
    before do
      allow(Rails.application.secrets).to receive(:dig).with(:metabase, :site_url).and_return(site_url)
    end

    it "returns site url" do
      expect(subject.metabase_site_url).to eq(site_url)
    end

    context "when site url is not defined" do
      let(:site_url) { nil }

      it "returns nil" do
        expect(subject.metabase_site_url).to be_nil
      end
    end
  end

  describe ".enabled?" do
    before do
      allow(Rails.application.secrets).to receive(:dig).with(:metabase, :enabled).and_return(enabled)
    end

    it "returns enabled" do
      expect(subject.metabase_enabled?).to eq(enabled)
    end

    context "when there is no enabled" do
      let(:enabled) { nil }

      it "returns nil" do
        expect(subject.metabase_enabled?).to be_nil
      end
    end
  end
end
