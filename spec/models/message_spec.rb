require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      message = Message.new(body: 'Test body')
      expect(message).not_to be_valid
    end

    it 'validates presence of body' do
      message = Message.new(title: 'Test title')
      expect(message).not_to be_valid
    end

    it 'validates presence of project' do
      message = Message.new(title: 'Test', body: 'Body')
      expect(message).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to author' do
      message = create(:message)
      expect(message.author).to be_a(User)
    end

    it 'belongs to project' do
      message = create(:message)
      expect(message.project).to be_a(Project)
    end

    it 'has many comments' do
      message = create(:message)
      comment = create(:comment, commentable: message)
      expect(message.comments).to include(comment)
    end

    it 'has many tags through taggings' do
      message = create(:message)
      tag = create(:tag)
      Tagging.create(tag: tag, taggable: message)
      expect(message.tags).to include(tag)
    end
  end

  describe 'normalizes' do
    it 'strips title and body' do
      message = create(:message, title: '  Hello  ', body: '  World  ')
      expect(message.title).to eq('Hello')
      expect(message.body).to eq('World')
    end
  end

  describe 'pg_search' do
    it 'searches by title' do
      message = create(:message, title: 'Important announcement')
      create(:message, title: 'Random note')

      results = Message.search('announcement')
      expect(results).to include(message)
    end
  end
end
