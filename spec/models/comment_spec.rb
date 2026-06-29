require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'validates presence of body' do
      comment = Comment.new
      expect(comment).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to author' do
      comment = create(:comment)
      expect(comment.author).to be_a(User)
    end

    it 'belongs to commentable' do
      comment = create(:comment)
      expect(comment.commentable).to be_present
    end
  end
end
