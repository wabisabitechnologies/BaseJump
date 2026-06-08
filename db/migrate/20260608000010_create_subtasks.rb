class CreateSubtasks < ActiveRecord::Migration[8.0]
  def change
    create_table :subtasks do |t|
      t.string :title, null: false
      t.boolean :done, default: false, null: false
      t.references :parent_todo, null: false, foreign_key: { to_table: :todos }
      t.timestamps
    end
  end
end