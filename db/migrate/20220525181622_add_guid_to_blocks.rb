class AddGuidToBlocks < ActiveRecord::Migration[7.0]
  def change
    add_column :blocks, :guid, :string, null: false

    change_table :blocks do |t|
      t.index :guid, unique: true
    end
  end
end
