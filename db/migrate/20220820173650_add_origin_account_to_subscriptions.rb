class AddOriginAccountToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.references :origin_account, foreign_key: {to_table: :accounts}
    end
  end
end
