class AddWindowRefToLists < ActiveRecord::Migration[6.1]
  def change
    add_reference :lists, :window, null: false, foreign_key: true
  end
end
