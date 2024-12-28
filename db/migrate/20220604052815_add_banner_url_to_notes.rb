class AddBannerUrlToNotes < ActiveRecord::Migration[7.0]
  def change
    change_table :notes do |t|
      t.text :banner_url, null: true
    end
  end
end
