class MoveContentToRichText < ActiveRecord::Migration[7.0]
  def change
    remove_column :blocks, :content
  end
end
