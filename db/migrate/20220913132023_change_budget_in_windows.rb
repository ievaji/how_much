class ChangeBudgetInWindows < ActiveRecord::Migration[6.1]
  def change
    change_column_default :lists, :budget, from: nil, to: 0.0
  end
end
