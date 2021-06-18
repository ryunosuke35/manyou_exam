class RenamePriorityColumnToStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :priority, :status
  end
end
