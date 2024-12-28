class AddDefaultToFillInValues < ActiveRecord::Migration[7.0]
  def change
    change_column :note_instances, :fill_in_values, :jsonb, default: {}
  end
end
