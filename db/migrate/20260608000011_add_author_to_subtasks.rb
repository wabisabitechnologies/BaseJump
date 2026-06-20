class AddAuthorToSubtasks < ActiveRecord::Migration[8.0]
  def change
    add_reference :subtasks, :author, null: false, foreign_key: { to_table: :users }
  end
end