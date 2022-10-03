class RenameColumnInLists < ActiveRecord::Migration[6.1]
  def change
    rename_column :lists, :current_value, :value
  end
end
