class RemoveTrackerRefFromLists < ActiveRecord::Migration[6.1]
  def change
    remove_column :lists, :tracker_id
  end
end
