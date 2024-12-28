class AddTypeToBlocks < ActiveRecord::Migration[7.0]
  def change
    change_table :blocks do |t|
      t.string :type, default: "Block"
    end
  end
end
