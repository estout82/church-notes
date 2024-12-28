class AddParentAccountToAccount < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.references :parent_account, foreign_key: {to_table: :accounts}
      t.boolean :can_have_sub_accounts, default: false
    end
  end
end
