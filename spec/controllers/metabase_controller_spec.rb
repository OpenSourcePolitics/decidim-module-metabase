# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe MetabaseController, type: :controller do
        routes { Decidim::Core::Engine.routes }
        let(:organization) { create :organization }

        before do
          request.env["decidim.current_organization"] = organization
        end

        describe "#urls" do
          let(:urls) { %w(url_1 url_2) }

          before do
            allow(MetabaseService).to receive(:urls_for).with(organization).and_return(urls)
          end

          it "returns list of url" do
            expect(controller.send(:urls)).to eq(urls)
          end
        end

        describe "#metabase_enabled?" do
          let(:enabled) { true }

          before do
            allow(Decidim::Metabase::MetabaseCredentials).to receive(:metabase_enabled?).and_return(enabled)
          end

          it "returns truthy" do
            expect(controller.send(:metabase_enabled?)).to be_truthy
          end

          context "when metabase is disabled" do
            let(:enabled) { false }

            it "returns falsey" do
              expect(controller.send(:metabase_enabled?)).to be_falsey
            end
          end
        end
      end
    end
  end
end
