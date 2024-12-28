class AddNoteInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :note_instances do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end

    create_table :note_instance_fill_ins do |t|
      t.references :instance, null: false, foreign_key: {to_table: :note_instances}
      t.string :guid
      t.text :value
      t.integer :kind
      t.timestamps
    end
  end
end
