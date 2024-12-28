class AddExternalTokenToExternalIdentityProviders < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identity_providers do |t|
      t.text :token
    end
  end
end
