# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action unless user&.admin?

          allow! if access_metabase?

          permission_action
        end

        def access_metabase?
          permission_action.subject == :metabase &&
            permission_action.action == :read
        end
      end
    end
  end
end
