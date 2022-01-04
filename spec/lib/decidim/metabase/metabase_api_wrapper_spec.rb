# frozen_string_literal: true

require "spec_helper"

describe Decidim::Metabase::MetabaseApiWrapper do
  subject { described_class }

  let(:site_url) { "https://fake_site_url" }

  describe ".request_path" do
    let(:expected_path) { "#{site_url}/dummy_path" }

    before do
      allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_site_url).and_return(site_url)
    end

    it "returns a path" do
      expect(subject.request_path("/dummy_path")).to eq(URI(expected_path))
    end
  end
end
