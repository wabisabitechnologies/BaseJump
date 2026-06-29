require 'rails_helper'

RSpec.describe 'Search', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }

  before { login_as(user) }

  describe 'GET /search' do
    it 'returns results with no query' do
      get search_path
      expect(response).to have_http_status(:ok)
    end

    it 'searches messages' do
      create(:message, project: project, author: user, title: 'Important Announcement')
      get search_path, params: { q: 'announcement' }
      expect(response).to have_http_status(:ok)
    end
  end
end
