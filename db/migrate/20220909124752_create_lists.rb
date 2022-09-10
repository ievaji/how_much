class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.string :name, index: true
      t.float :budget
      t.float :current_value
      t.references :user, null: false, foreign_key: true, index: true
      t.references :window, null: false, foreign_key: true, index: true
      t.references :tracker, foreign_key: { to_table: :windows }, index: true

      t.timestamps
    end
  end
end
