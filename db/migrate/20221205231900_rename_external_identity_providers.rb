class RenameExternalIdentityProviders < ActiveRecord::Migration[7.0]
  def change
    rename_table :external_identity_providers, :integrations
    rename_column :integrations, :provider_root_url, :integration_root_url
  end
end
