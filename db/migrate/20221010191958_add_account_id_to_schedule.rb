class AddAccountIdToSchedule < ActiveRecord::Migration[7.0]
  def change
    change_table :schedules do |t|
      t.references :account, foreign_key: true
    end
  end
end
