require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      event = Event.new(start_date: Date.tomorrow, end_date: Date.tomorrow + 1)
      expect(event).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to author' do
      event = create(:event)
      expect(event.author).to be_a(User)
    end

    it 'belongs to project' do
      event = create(:event)
      expect(event.project).to be_a(Project)
    end

    it 'has many comments' do
      event = create(:event)
      comment = create(:comment, commentable: event)
      expect(event.comments).to include(comment)
    end
  end
end
