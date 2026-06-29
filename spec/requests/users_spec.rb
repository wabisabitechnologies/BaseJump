require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/new (signup page)' do
    it 'renders signup form' do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users (signup)' do
    let(:valid_params) do
      {
        user: {
          name: 'New User',
          username: 'newuser',
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          company_name: 'Test Company'
        }
      }
    end

    it 'creates a new user' do
      expect { post users_path, params: valid_params }.to change(User, :count).by(1)
      expect(response).to redirect_to('/home')
    end

    it 'rejects invalid signup' do
      post users_path, params: { user: { name: '', username: '', email: '', password: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
