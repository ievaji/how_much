class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :item_name, index: true
      t.float :value

      t.timestamps
    end
  end
end
