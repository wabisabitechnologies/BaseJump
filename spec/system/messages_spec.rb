require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = create(:user)
    login_as_system(@user)
    @project = create(:project, company: @user.company)
    UserProject.create(user: @user, project: @project)
  end

  describe 'message board' do
    let!(:message) { create(:message, project: @project, author: @user, title: 'Important Notice', body: 'Please read this') }

    it 'shows messages list' do
      visit project_messages_path(@project)
      expect(page).to have_content('Important Notice')
    end

    it 'shows message detail' do
      visit project_message_path(@project, message)
      expect(page).to have_content('Important Notice')
      expect(page).to have_content('Please read this')
    end
  end
end
