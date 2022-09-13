class CreateWindows < ActiveRecord::Migration[6.1]
  def change
    create_table :windows do |t|
      t.string :window_name, index: true
      t.float :budget
      t.float :current_value, default: 0.00
      t.float :difference
      t.boolean :exceeded, default: false
      t.date :start_date, index: true
      t.date :end_date
      t.integer :size, index: true
      t.boolean :closed, default: false, index: true

      t.timestamps
    end
  end
end
