require 'rails_helper'

RSpec.describe 'Everything', type: :request do
  let(:user) { create(:user) }

  before { login_as(user) }

  describe 'GET /everything' do
    it 'shows all items across projects' do
      project = create(:project, company: user.company)
      create(:todo, author: user, title: 'My Todo')
      create(:message, project: project, author: user, title: 'My Message')

      get everything_index_path
      expect(response).to have_http_status(:ok)
    end

    it 'filters by todos' do
      get everything_index_path, params: { filter: 'todos' }
      expect(response).to have_http_status(:ok)
    end
  end
end
