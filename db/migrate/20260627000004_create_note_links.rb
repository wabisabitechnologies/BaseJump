class CreateNoteLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :note_links do |t|
      t.bigint :source_note_id, null: false
      t.bigint :target_note_id, null: false
      t.timestamps
    end

    add_index :note_links, [:source_note_id, :target_note_id], unique: true
    add_index :note_links, :target_note_id
    
    add_foreign_key :note_links, :notes, column: :source_note_id
    add_foreign_key :note_links, :notes, column: :target_note_id
  end
end
