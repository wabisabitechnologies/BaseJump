class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :avatar_url
      t.string :job_title
      t.boolean :admin
      t.boolean :owner
      t.string :password_digest, null: false
      t.string :session_token, null: false
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :session_token, unique: true
  end
end