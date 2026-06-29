require 'rails_helper'

RSpec.describe 'Projects', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = create(:user)
    login_as_system(@user)
    @project = create(:project, company: @user.company, name: 'Test Project')
    UserProject.create(user: @user, project: @project)
  end

  describe 'project list' do
    it 'shows projects for user' do
      visit home_path
      expect(page).to have_content('Test Project')
    end
  end

  describe 'project dashboard' do
    it 'shows project page with tools' do
      visit project_path(@project)
      expect(page).to have_content(@project.name)
      expect(page).to have_link('Todo Lists')
      expect(page).to have_link('Messages')
      expect(page).to have_link('Events')
      expect(page).to have_link('Docs')
    end
  end
end
