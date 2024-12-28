class AddStatusToSubscription < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.integer :status, default: 0 # enum [:no_status, :active, :canceled, :failed, :inactive]
    end
  end
end
