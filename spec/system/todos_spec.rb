require 'rails_helper'

RSpec.describe 'Todos', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = create(:user)
    login_as_system(@user)
    @project = create(:project, company: @user.company)
    UserProject.create(user: @user, project: @project)
    @todo_list = create(:todo_list, project: @project, author: @user)
  end

  describe 'todo list page' do
    let!(:todo) { create(:todo, author: @user, todo_list: @todo_list, title: 'My Task') }

    it 'shows todo list with todos' do
      visit project_todo_list_path(@project, @todo_list)
      expect(page).to have_content(@todo_list.title)
      expect(page).to have_content('My Task')
    end
  end
end
