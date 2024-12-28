class AddActionDataModel < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.references :note, foreign_key: true
      t.string :type
      t.jsonb :data, default: {}
      t.timestamps
    end

    create_table :action_executions do |t|
      t.references :action, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamp :run_at
      t.integer :status, default: 0 # initial, completed, failed
      t.jsonb :data, default: {}
      t.timestamps
    end

    create_table :messages do |t|
      t.references :sender, null: true, foreign_key: { to_table: :users }
      t.references :recipient, polymorphic: true, null: false
      t.text :content
      t.jsonb :data
    end
  end
end
