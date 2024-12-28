class AddBlockReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :block_references do |t|
      t.references :note, foreign_key: true, null: false
      t.string :referenced_block_id
      t.timestamps

      t.index :referenced_block_id, unique: true
    end
  end
end
