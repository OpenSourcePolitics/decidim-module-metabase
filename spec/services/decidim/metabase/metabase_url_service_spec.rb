# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    describe MetabaseUrlService do
      subject { described_class.new(1) }

      let(:enabled) { true }
      let(:site_url) { "fake_site_url" }
      let(:secret_key) { "fake_secret_key" }
      let(:organization) { create(:organization, metabase_configuration: metabase_configuration) }

      before do
        allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_site_url).and_return(site_url)
        allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_secret_key).and_return(secret_key)
      end

      describe "#url" do
        it "returns an url" do
          expect(subject.url).to start_with("fake_site_url/embed/dashboard/")
          expect(subject.url).to end_with("#bordered=true&titled=true")
        end
      end

      describe ".run" do
        before do
          allow(Decidim::Metabase::MetabaseUrlService).to receive(:new).with(1).and_call_original
        end

        it "creates a new instance" do
          url = Decidim::Metabase::MetabaseUrlService.run(1)

          expect(Decidim::Metabase::MetabaseUrlService).to have_received(:new).with(1)
          expect(url).to start_with("fake_site_url/embed/dashboard/")
          expect(url).to end_with("#bordered=true&titled=true")
        end
      end
    end
  end
end
