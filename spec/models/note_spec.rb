require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      note = Note.new(body: 'Test body')
      expect(note).not_to be_valid
      expect(note.errors[:title]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to author' do
      note = create(:note)
      expect(note.author).to be_a(User)
    end

    it 'belongs to project' do
      note = create(:note)
      expect(note.project).to be_a(Project)
    end

    it 'belongs to parent optionally' do
      child = create(:note, :child)
      expect(child.parent).to be_a(Note)
    end

    it 'has many children' do
      root = create(:note, :root)
      child = create(:note, parent: root)
      expect(root.children).to include(child)
    end

    it 'has many taggings' do
      note = create(:note)
      tag = create(:tag)
      Tagging.create(tag: tag, taggable: note)
      expect(note.taggings.count).to eq(1)
    end

    it 'has many outgoing links' do
      note_a = create(:note)
      note_b = create(:note)
      NoteLink.create(source_note: note_a, target_note: note_b)
      expect(note_a.outgoing_links.count).to eq(1)
    end

    it 'has many incoming links' do
      note_a = create(:note)
      note_b = create(:note)
      NoteLink.create(source_note: note_a, target_note: note_b)
      expect(note_b.incoming_links.count).to eq(1)
    end
  end

  describe 'scopes' do
    it 'returns root notes' do
      root = create(:note, :root)
      child = create(:note, :child)

      expect(Note.roots).to include(root)
      expect(Note.roots).not_to include(child)
    end
  end

  describe '#root?' do
    it 'returns true for root notes' do
      note = create(:note, :root)
      expect(note.root?).to be true
    end

    it 'returns false for child notes' do
      note = create(:note, :child)
      expect(note.root?).to be false
    end
  end

  describe '#ancestors' do
    it 'returns ancestor chain' do
      root = create(:note, :root)
      child = create(:note, parent: root)
      grandchild = create(:note, parent: child)

      expect(grandchild.ancestors).to eq([root, child])
    end
  end

  describe '#extract_wiki_links' do
    it 'extracts [[wiki links]] from body' do
      note = create(:note, body: 'See [[Other Note]] for details')
      expect(note.extract_wiki_links).to eq(['Other Note'])
    end

    it 'returns empty array when no links' do
      note = create(:note, body: 'No links here')
      expect(note.extract_wiki_links).to eq([])
    end

    it 'deduplicates links' do
      note = create(:note, body: 'See [[Note]] and [[Note]] again')
      expect(note.extract_wiki_links).to eq(['Note'])
    end
  end

  describe '#body_with_links' do
    it 'replaces wiki links with HTML links' do
      linked = create(:note, title: 'Other Note')
      note = create(:note, body: 'See [[Other Note]] for details')

      result = note.body_with_links
      expect(result).to include('<a href="/projects/' + linked.project_id.to_s + '/docs/' + linked.id.to_s + '"')
      expect(result).to include('Other Note')
    end

    it 'leaves unmatched links as-is' do
      note = create(:note, body: 'See [[Nonexistent]] for details')
      result = note.body_with_links
      expect(result).to include('[[Nonexistent]]')
    end
  end

  describe 'pg_search' do
    it 'searches by title' do
      note = create(:note, title: 'Architecture decisions')
      create(:note, title: 'Meeting notes')

      results = Note.search('architecture')
      expect(results).to include(note)
    end
  end
end
