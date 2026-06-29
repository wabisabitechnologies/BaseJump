require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  let(:user) { create(:user) }

  before { login_as(user) }

  describe 'GET /tags' do
    it 'lists all tags' do
      create(:tag, name: 'urgent')
      get tags_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /tags' do
    it 'creates a tag' do
      expect {
        post tags_path, params: { tag: { name: 'important', color: '#ff0000' } }, as: :turbo_stream
      }.to change(Tag, :count).by(1)
    end
  end

  describe 'POST /messages/:message_id/tags' do
    it 'tags a message' do
      message = create(:message, author: user, project: create(:project, company: user.company))
      post tag_message_path(message), params: { tag_name: 'pinned' }
      expect(message.reload.tags.pluck(:name)).to include('pinned')
    end
  end

  describe 'DELETE /messages/:message_id/tags/:tag_id' do
    it 'untags a message' do
      message = create(:message, author: user, project: create(:project, company: user.company))
      tag = create(:tag, name: 'pinned')
      message.tags << tag

      delete untag_message_path(message, tag_id: tag.id)
      expect(message.reload.tags).not_to include(tag)
    end
  end
end
