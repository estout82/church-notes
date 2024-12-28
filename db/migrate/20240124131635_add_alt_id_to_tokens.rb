class AddAltIdToTokens < ActiveRecord::Migration[7.0]
  def change
    change_table :tokens do |t|
      t.string :alt_id, unique: true, null: false
    end
  end
end
