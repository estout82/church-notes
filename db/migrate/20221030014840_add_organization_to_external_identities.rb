class AddOrganizationToExternalIdentities < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identities do |t|
      t.references :organization, foreign_key: true
    end
  end
end
