class CreateJoinTableWindowWindow < ActiveRecord::Migration[6.1]
  def change
    create_table :windows_windows, id: false do |t|
      t.bigint :tracker_id
      t.bigint :tracked_window_id
    end

    add_index :windows_windows, :tracker_id
    add_index :windows_windows, :tracked_window_id
  end
end
