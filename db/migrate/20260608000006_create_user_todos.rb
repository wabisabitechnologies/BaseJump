class CreateUserTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_todos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :todo, null: false, foreign_key: true
      t.timestamps
    end
    add_index :user_todos, [:user_id, :todo_id], unique: true
  end
end