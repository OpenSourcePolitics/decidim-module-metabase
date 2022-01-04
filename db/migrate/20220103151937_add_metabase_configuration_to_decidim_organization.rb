# frozen_string_literal: true

class AddMetabaseConfigurationToDecidimOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_organizations, :metabase_configuration, :jsonb
  end
end
