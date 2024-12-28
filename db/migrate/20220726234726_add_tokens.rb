class AddTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.integer :action, default: 0 # enum
      t.text :value, null: false
      t.boolean :active, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
