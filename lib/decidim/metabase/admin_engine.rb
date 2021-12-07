# frozen_string_literal: true

module Decidim
  module Metabase
    # This is the engine that runs on the public interface of `Metabase`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Metabase::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :metabase do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "metabase#index"
      end

      def load_seed
        nil
      end
    end
  end
end
