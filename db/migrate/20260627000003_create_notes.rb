class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body
      t.bigint :author_id
      t.bigint :project_id
      t.bigint :parent_id
      t.integer :position, default: 0
      t.boolean :published, default: false
      t.timestamps
    end

    add_index :notes, :author_id
    add_index :notes, :project_id
    add_index :notes, :parent_id
    add_index :notes, [:project_id, :parent_id]
    add_index :notes, [:project_id, :position]
    
    add_foreign_key :notes, :users, column: :author_id
    add_foreign_key :notes, :projects
    add_foreign_key :notes, :notes, column: :parent_id
  end
end
