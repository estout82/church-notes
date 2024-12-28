class AddSettingsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.jsonb :settings
    end
  end
end
