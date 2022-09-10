class CreateWindows < ActiveRecord::Migration[6.1]
  def change
    create_table :windows do |t|
      t.string :name, index: true
      t.float :budget
      t.float :current_value
      t.date :start_date, index: true
      t.date :end_date
      t.integer :size
      t.boolean :closed, default: false, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.references :tracker, foreign_key: { to_table: :windows }, index: true

      t.timestamps
    end
  end
end
