class AddBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :note, notes: true, null: false, foreign_key: true
      t.text :content
      t.integer :kind, default: 0
      t.jsonb :meta
      t.integer :order, default: 0
      t.timestamps
    end

    remove_column :notes, :content
  end
end
