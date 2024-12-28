class RemoveUnusedSubscriptionColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.remove :current_period_start
      t.remove :current_period_end
      t.remove :billing_first_name
      t.remove :billing_last_name
      t.remove :billing_email
    end
  end
end
