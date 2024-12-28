class AddEncodedNameToOrganizations < ActiveRecord::Migration[7.0]
  def change
    change_table :organizations do |t|
      t.string :encoded_name
      t.index :encoded_name, unique: true
    end
  end
end
