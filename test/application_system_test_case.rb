require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  def login_as(user)
    visit new_session_path
    fill_in 'session_username_or_email', with: user.username
    fill_in 'session_password', with: 'password'
    click_button 'Log in'
  end
end