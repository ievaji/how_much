class CreateJoinTableListList < ActiveRecord::Migration[6.1]
  def change
    create_table :lists_lists, id: false do |t|
      t.bigint :tracker_id
      t.bigint :tracked_list_id
    end

    add_index :lists_lists, :tracker_id
    add_index :lists_lists, :tracked_list_id
  end
end
