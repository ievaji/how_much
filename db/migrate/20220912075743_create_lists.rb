class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.string :list_name, index: true
      t.float :budget
      t.float :current_value, default: 0.00
      t.float :difference
      t.boolean :exceeded, default: false

      t.timestamps
    end
  end
end
