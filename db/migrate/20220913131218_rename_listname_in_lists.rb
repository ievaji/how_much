class RenameListnameInLists < ActiveRecord::Migration[6.1]
  def change
    rename_column :lists, :list_name, :name
  end
end
