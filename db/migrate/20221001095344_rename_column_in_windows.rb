class RenameColumnInWindows < ActiveRecord::Migration[6.1]
  def change
    rename_column :windows, :current_value, :value
  end
end
