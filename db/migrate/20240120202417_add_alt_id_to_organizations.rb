class AddAltIdToOrganizations < ActiveRecord::Migration[7.0]
  def change
    change_table :organizations do |t|
      t.string :alt_id, null: false, unique: true
    end
  end
end
