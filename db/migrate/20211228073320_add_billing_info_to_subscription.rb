class AddBillingInfoToSubscription < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.string :billing_first_name
      t.string :billing_last_name
      t.string :billing_email
    end
  end
end
