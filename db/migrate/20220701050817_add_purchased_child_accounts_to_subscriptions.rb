class AddPurchasedChildAccountsToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.integer :purchased_child_accounts, default: 0
    end
  end
end
