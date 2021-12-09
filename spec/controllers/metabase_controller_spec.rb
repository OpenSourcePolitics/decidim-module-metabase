# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe MetabaseController, type: :controller do
        routes { Decidim::Core::Engine.routes }

        describe "#urls" do
          let(:urls) { %w(url_1 url_2) }

          before do
            allow(MetabaseService).to receive(:urls).and_return(urls)
          end

          it "returns list of url" do
            expect(controller.send(:urls)).to eq(urls)
          end
        end

        describe "#metabase_enabled?" do
          let(:enabled) { true }
          let(:metabase_secrets) do
            {
              enabled: enabled
            }
          end

          before do
            allow(Rails.application.secrets).to receive(:metabase).and_return(metabase_secrets)
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

          context "when metabase enable settings is not defined" do
            let(:metabase_secrets) do
              {}
            end

            it "returns falsey" do
              expect(controller.send(:metabase_enabled?)).to be_falsey
            end
          end
        end
      end
    end
  end
end
