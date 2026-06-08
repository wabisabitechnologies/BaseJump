class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.references :author, null: true, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.string :start_date, null: false
      t.string :end_date, null: false
      t.string :video_link
      t.timestamps
    end
  end
end