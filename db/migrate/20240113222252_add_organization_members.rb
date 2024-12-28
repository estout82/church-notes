class AddOrganizationMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_members do |t|
      t.references :organization
      t.references :user
      t.timestamps
    end

    remove_column :users, :organization_id
  end
end
