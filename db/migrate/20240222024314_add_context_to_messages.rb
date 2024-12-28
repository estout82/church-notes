class AddContextToMessages < ActiveRecord::Migration[7.0]
  def change
    change_table :messages do |t|
      t.references :context, polymorphic: true, null: true
    end
  end
end
