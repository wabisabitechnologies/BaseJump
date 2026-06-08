class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :message_type
      t.references :author, null: true, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end