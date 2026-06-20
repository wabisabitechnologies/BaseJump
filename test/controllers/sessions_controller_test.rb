require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @company = Company.create!(name: 'Test Company')
    @user = User.create!(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
  end

  test 'should show login page' do
    get '/session/new'
    assert_response :success
  end

  test 'login with valid credentials' do
    post '/session', params: {
      session: {
        username_or_email: @user.username,
        password: 'password123'
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_equal @user.reload.session_token, session[:session_token]
  end

  test 'login with invalid credentials' do
    post '/session', params: {
      session: {
        username_or_email: @user.username,
        password: 'wrongpassword'
      }
    }
    assert_response :unprocessable_entity
  end
end