class AddTimestampsToMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :messages do |t|
      t.timestamps
    end
  end
end
