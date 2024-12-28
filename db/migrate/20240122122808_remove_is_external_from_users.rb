class RemoveIsExternalFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_external
  end
end
