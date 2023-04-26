# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      class ApplicationController < Decidim::Admin::ApplicationController
        before_action :authorized?

        def permission_class_chain
          [::Decidim::Metabase::Admin::Permissions] + super
        end

        def user_not_authorized_path
          decidim.root_path
        end

        def user_has_no_permission_path
          decidim.root_path
        end

        def authorized?
          enforce_permission_to :read, :metabase
        end
      end
    end
  end
end
