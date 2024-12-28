class CreateInteractions < ActiveRecord::Migration[7.0]
  def change
    create_table :interactions do |t|
      t.string :type
      t.references :user, null: true
      t.jsonb :data

      t.timestamps
    end
  end
end
