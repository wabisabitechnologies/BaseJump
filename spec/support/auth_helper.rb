module AuthHelper
  def login_as(user)
    user.reset_session_token!
    post session_path, params: { session: { username_or_email: user.username, password: 'password123' } }
  end

  def login_as_system(user)
    visit root_path
    fill_in 'session[username_or_email]', with: user.username
    fill_in 'session[password]', with: 'password123'
    click_button 'Login'
    expect(page).to have_current_path('/home') if page.body.include?('/home')
  end
end
