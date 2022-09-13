class RenameItemnameInItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :item_name, :name
  end
end
