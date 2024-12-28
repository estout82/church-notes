class AddAccountToInteraction < ActiveRecord::Migration[7.0]
  def change
    change_table :interactions do |t|
      t.references :account, null: true
    end
  end
end
