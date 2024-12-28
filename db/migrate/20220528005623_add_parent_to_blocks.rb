class AddParentToBlocks < ActiveRecord::Migration[7.0]
  def change
    change_table :blocks do |t|
      t.references :parent, foreign_key: {to_table: :blocks}, null: true
    end
  end
end
