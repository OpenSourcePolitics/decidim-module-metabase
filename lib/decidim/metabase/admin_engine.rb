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
        root to: "metabase#index"
      end

      initializer "Metabase.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::Metabase::AdminEngine, at: "/admin/metabase", as: "decidim_metabase"
        end
      end

      initializer "Metabase.admin_menu_add_item" do
        Decidim.menu :admin_menu do |menu|
          menu.add_item :metabase,
                        t("decidim.admin.metabase.menu.title"),
                        decidim_metabase.root_path,
                        icon_name: "dashboard",
                        position: 11
        end
      end

      def load_seed
        nil
      end
    end
  end
end
