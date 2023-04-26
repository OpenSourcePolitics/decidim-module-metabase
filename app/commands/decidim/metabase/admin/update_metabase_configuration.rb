# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class UpdateMetabaseConfiguration < Rectify::Command
        def initialize(organization, form)
          @organization = organization
          @form = form
        end

        def call
          return broadcast(:invalid) if form.invalid?

          update_organization

          broadcast(:ok)
        end

        private

        def update_organization
          @organization.update!(metabase_configuration: {
                                  login: form.login,
                                  password: form.password,
                                  dashboard_ids: dashboard_ids
                                })
        end

        attr_reader :form

        def dashboard_ids
          ids = form.dashboard_ids
          return [] if form.dashboard_ids.nil?

          ids.split(",").map(&:to_i)
        end
      end
    end
  end
end
