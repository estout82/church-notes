class ChangeChildAccountToSubAccount < ActiveRecord::Migration[7.0]
  def change
    rename_column :subscriptions, :purchased_child_accounts, :purchased_sub_accounts
  end
end
