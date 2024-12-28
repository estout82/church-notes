class AddIsStaffToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.boolean :is_staff, default: false
    end
  end
end
