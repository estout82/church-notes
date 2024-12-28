class AddAltIdToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.string :alt_id
    end
  end
end
