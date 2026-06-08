class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :commentable, polymorphic: true, null: false
      t.timestamps
    end
  end
end