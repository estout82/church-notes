class AddRootUrlToExternalIdentityProviders < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identity_providers do |t|
      t.string :root_url
    end
  end
end
