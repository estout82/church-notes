class AddExternalTokenToExternalIdentities < ActiveRecord::Migration[7.0]
  def change
    change_table :external_identities do |t|
      t.text :token
    end
  end
end
