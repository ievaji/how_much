class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, index: true
      t.float :value
      t.date :date, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.references :list, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
