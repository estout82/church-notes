class AddSignUps < ActiveRecord::Migration[7.0]
  def change
    create_table :sign_ups do |t|
      t.string :alt_id, null: false
      t.references :organization, null: true
      t.references :subscription, null: true
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :source
      t.integer :plan
      t.jsonb :data
      t.timestamps

      t.index :alt_id, unique: true
    end
  end
end
