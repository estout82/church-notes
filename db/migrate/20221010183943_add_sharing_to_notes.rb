class AddSharingToNotes < ActiveRecord::Migration[7.0]
  def change
    change_table :notes do |t|
      t.integer :sharing, default: 0
    end
  end
end
