class AddHostToExternalIdentityProviders < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identity_providers do |t|
      t.string :authorization_endpoint
      t.string :token_endpoint
    end
  end
end
