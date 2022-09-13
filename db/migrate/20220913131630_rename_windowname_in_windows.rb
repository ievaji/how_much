class RenameWindownameInWindows < ActiveRecord::Migration[6.1]
  def change
    rename_column :windows, :window_name, :name
  end
end
