# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Metabase
    module Admin
      describe ApplicationController, type: :controller do
        routes { Decidim::Core::Engine.routes }

        describe "#user_not_authorized_path" do
          it "returns a path" do
            expect(controller.send(:user_not_authorized_path)).to eq("/")
          end
        end
      end
    end
  end
end
