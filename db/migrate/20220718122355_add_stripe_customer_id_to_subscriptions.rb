class AddStripeCustomerIdToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.string :stripe_customer_id
    end
  end
end
