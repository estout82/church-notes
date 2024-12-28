class AddIsExternalToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.boolean :is_external, default: false
    end
  end
end
