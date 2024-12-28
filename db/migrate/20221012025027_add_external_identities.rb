class AddExternalIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :external_identity_providers do |t|
      t.references :organization, foreign_key: true
      t.string :type
      t.string :client_id
      t.string :client_secret
      t.string :redirect_uri
      t.timestamps
    end

    create_table :external_identities do |t|
      t.references :user, foreign_key: true
      t.references :external_identity_provider, foreign_key: true
      t.string :external_id
      t.jsonb :data
      t.timestamps
    end
  end
end
