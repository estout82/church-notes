class RenameRootUrl < ActiveRecord::Migration[7.0]
  def change
    rename_column :external_identity_providers, :root_url, :provider_root_url
  end
end
