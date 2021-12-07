# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Metabase
    # This is the engine that runs on the public interface of metabase.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Metabase

      routes do
        # Add engine routes here
        # resources :metabase
        # root to: "metabase#index"
      end

      initializer "Metabase.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
