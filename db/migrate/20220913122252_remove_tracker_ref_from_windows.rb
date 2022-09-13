class RemoveTrackerRefFromWindows < ActiveRecord::Migration[6.1]
  def change
    remove_column :windows, :tracker_id
  end
end
