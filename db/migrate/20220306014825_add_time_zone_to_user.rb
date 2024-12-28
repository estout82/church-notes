class AddTimeZoneToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :time_zone, default: "Pacific Time (US & Canada)"
    end
  end
end
