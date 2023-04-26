# frozen_string_literal: true

module Decidim
  module Metabase
    module Admin
      class MetabaseConfigurationForm < Form
        include JsonbAttributes

        mimic :organization

        jsonb_attribute :metabase_configuration, [
          [:login, String],
          [:password, String],
          [:dashboard_ids, String]
        ]

        validate :dashboard_ids_format

        def dashboard_ids_format
          return if dashboard_ids.blank?
          return if /^([0-9]+)(,\s*[0-9]+)*$/i.match? dashboard_ids

          errors.add(:dashboard_ids, :format)
        end

        def map_model(model)
          self.login = model.metabase_configuration&.fetch(:login, nil)
          self.password = model.metabase_configuration&.fetch(:password, nil)
          self.dashboard_ids = model.metabase_configuration&.fetch(:dashboard_ids, nil)&.join(" ")
        end
      end
    end
  end
end
