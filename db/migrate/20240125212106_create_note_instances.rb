class CreateNoteInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :note_instances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :note, null: false, foreign_key: true
      t.jsonb :fill_in_values
      t.timestamps
    end
  end
end
