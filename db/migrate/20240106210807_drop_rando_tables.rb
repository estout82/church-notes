class DropRandoTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :action_text_rich_texts
    drop_table :blocks
    drop_table :external_identities
    drop_table :integrations
    drop_table :note_instance_fill_ins
    drop_table :note_instances
  end
end
