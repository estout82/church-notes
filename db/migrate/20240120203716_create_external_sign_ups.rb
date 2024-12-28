class CreateExternalSignUps < ActiveRecord::Migration[7.0]
  def change
    create_table :external_sign_ups do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :alt_id
      t.string :source
      t.string :interest_url
      t.timestamps
    end
  end
end
