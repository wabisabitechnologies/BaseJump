require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:user) { create(:user, username: 'testuser', email: 'test@example.com', password: 'password123') }

  describe 'login flow' do
    it 'logs in with valid credentials' do
      visit root_path
      fill_in 'session[username_or_email]', with: 'testuser'
      fill_in 'session[password]', with: 'password123'
      click_button 'Login'
      expect(page).to have_current_path('/home')
    end

    it 'shows error for invalid credentials' do
      visit root_path
      fill_in 'session[username_or_email]', with: 'testuser'
      fill_in 'session[password]', with: 'wrong'
      click_button 'Login'
      expect(page.body).to include('Invalid')
    end
  end

  describe 'signup flow' do
    it 'creates a new account' do
      visit new_user_path
      fill_in 'user[name]', with: 'New Person'
      fill_in 'user[username]', with: 'newperson'
      fill_in 'user[email]', with: 'new@example.com'
      fill_in 'user_company_name', with: 'New Company'
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'
      click_button 'Sign Up'
      expect(page).to have_current_path('/home')
      expect(User.find_by(username: 'newperson')).to be_present
    end

    it 'creates company and Company HQ project' do
      visit new_user_path
      fill_in 'user[name]', with: 'Company Person'
      fill_in 'user[username]', with: 'companyperson'
      fill_in 'user[email]', with: 'company@example.com'
      fill_in 'user_company_name', with: 'Acme Corp'
      fill_in 'user[password]', with: 'password123'
      fill_in 'user[password_confirmation]', with: 'password123'
      click_button 'Sign Up'

      expect(page).to have_current_path('/home')
      new_user = User.find_by(username: 'companyperson')
      expect(new_user).to be_present
      expect(new_user.company).to be_present
      expect(new_user.company.projects.find_by(name: 'Company HQ')).to be_present
    end
  end
end
