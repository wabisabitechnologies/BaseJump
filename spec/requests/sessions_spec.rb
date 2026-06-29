require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user, username: 'testuser', password: 'password123') }

  describe 'GET / (login page)' do
    it 'renders login form' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /session (login)' do
    it 'logs in with valid credentials' do
      post session_path, params: { session: { username_or_email: 'testuser', password: 'password123' } }
      expect(response).to redirect_to('/home')
    end

    it 'logs in with email' do
      post session_path, params: { session: { username_or_email: user.email, password: 'password123' } }
      expect(response).to redirect_to('/home')
    end

    it 'rejects invalid credentials' do
      post session_path, params: { session: { username_or_email: 'testuser', password: 'wrong' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /session (logout)' do
    it 'logs out the user' do
      login_as(user)
      delete session_path
      expect(response).to redirect_to('/')
    end
  end
end
