class RenameExternalIdentityProviderId < ActiveRecord::Migration[7.0]
  def change
    rename_column :external_identities, :external_identity_provider_id, :integration_id
  end
end
