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
      end
    end
  end
end
