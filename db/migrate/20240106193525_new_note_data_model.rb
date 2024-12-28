class NewNoteDataModel < ActiveRecord::Migration[7.0]
  def change
    change_table :notes do |t|
      t.jsonb :editor_data, default: {}
    end
  end
end
