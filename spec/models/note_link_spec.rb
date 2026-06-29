require 'rails_helper'

RSpec.describe NoteLink, type: :model do
  describe 'validations' do
    it 'validates uniqueness of source_note_id scoped to target_note_id' do
      note_a = create(:note)
      note_b = create(:note)
      NoteLink.create!(source_note: note_a, target_note: note_b)

      duplicate = NoteLink.new(source_note: note_a, target_note: note_b)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to source_note' do
      link = create(:note_link)
      expect(link.source_note).to be_a(Note)
    end

    it 'belongs to target_note' do
      link = create(:note_link)
      expect(link.target_note).to be_a(Note)
    end
  end

  describe 'callbacks' do
    it 'prevents self-referencing links' do
      note = create(:note)
      link = NoteLink.new(source_note: note, target_note: note)
      expect(link).not_to be_valid
      expect(link.errors[:target_note]).to include("can't link to itself")
    end

    it 'creates reverse link automatically' do
      note_a = create(:note)
      note_b = create(:note)

      NoteLink.create!(source_note: note_a, target_note: note_b)

      expect(NoteLink.exists?(source_note_id: note_b.id, target_note_id: note_a.id)).to be true
    end

    it 'destroys reverse link automatically' do
      note_a = create(:note)
      note_b = create(:note)
      link = NoteLink.create!(source_note: note_a, target_note: note_b)

      link.destroy
      expect(NoteLink.exists?(source_note_id: note_b.id, target_note_id: note_a.id)).to be false
    end
  end
end
