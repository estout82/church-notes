class AddVerificationToExternalIdentityProviders < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identity_providers do |t|
      t.boolean :verified, default: false
      t.datetime :verified_at
      t.jsonb :data
    end
  end
end
