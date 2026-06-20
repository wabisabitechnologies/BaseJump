class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.string :project_type, null: false
      t.references :admin, null: true, foreign_key: { to_table: :users }
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
  end
end