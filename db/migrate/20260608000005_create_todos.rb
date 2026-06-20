class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description
      t.references :author, null: true, foreign_key: { to_table: :users }
      t.boolean :done, default: false, null: false
      t.references :todo_list, null: true, foreign_key: true
      t.datetime :due_date
      t.timestamps
    end
  end
end