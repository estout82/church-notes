class DropRedirectUri < ActiveRecord::Migration[7.0]
  def change
    remove_column :external_identity_providers, :redirect_uri
  end
end
