class AddAltIdToNotes < ActiveRecord::Migration[7.0]
  def change
    change_table :notes do |t|
      t.string :alt_id
    end
  end
end
