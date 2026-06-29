require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      tag = Tag.new
      expect(tag).not_to be_valid
    end

    it 'validates uniqueness of name' do
      create(:tag, name: 'urgent')
      dup = build(:tag, name: 'urgent')
      expect(dup).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many taggings' do
      tag = create(:tag)
      message = create(:message)
      Tagging.create(tag: tag, taggable: message)
      expect(tag.taggings.count).to eq(1)
    end
  end

  describe 'normalizes' do
    it 'strips and downcases name' do
      tag = create(:tag, name: '  Important  ')
      expect(tag.name).to eq('important')
    end
  end
end

RSpec.describe Tagging, type: :model do
  describe 'associations' do
    it 'belongs to tag' do
      tagging = create(:tagging)
      expect(tagging.tag).to be_a(Tag)
    end

    it 'belongs to taggable' do
      tagging = create(:tagging)
      expect(tagging.taggable).to be_a(Message)
    end
  end
end
