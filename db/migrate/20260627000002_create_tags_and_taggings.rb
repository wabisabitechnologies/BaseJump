class CreateTagsAndTaggings < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :color
      t.timestamps
    end
    
    add_index :tags, :name, unique: true

    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false
      t.timestamps
    end
    
    add_index :taggings, [:tag_id, :taggable_type, :taggable_id], unique: true
  end
end
