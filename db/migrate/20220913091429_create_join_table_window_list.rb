class CreateJoinTableWindowList < ActiveRecord::Migration[6.1]
  def change
    create_table :windows_lists, id: false do |t|
      t.bigint :tracker_id
      t.bigint :tracked_list_id
    end

    add_index :windows_lists, :tracker_id
    add_index :windows_lists, :tracked_list_id
  end
end
