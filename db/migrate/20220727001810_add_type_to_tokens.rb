class AddTypeToTokens < ActiveRecord::Migration[7.0]
  def change
    change_table :tokens do |t|
      t.string :type
    end
  end
end
