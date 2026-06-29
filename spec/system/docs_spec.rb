require 'rails_helper'

RSpec.describe 'Docs', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = create(:user)
    login_as_system(@user)
    @project = create(:project, company: @user.company)
    UserProject.create(user: @user, project: @project)
  end

  describe 'docs index' do
    it 'shows docs list' do
      doc = create(:note, project: @project, author: @user, title: 'My Page')
      visit project_docs_path(@project)
      expect(page).to have_content('My Page')
    end
  end

  describe 'wiki linking' do
    it 'creates links between docs' do
      doc_a = create(:note, project: @project, author: @user, title: 'Page A', body: 'See [[Page B]] for details')
      doc_b = create(:note, project: @project, author: @user, title: 'Page B')

      visit project_doc_path(@project, doc_a)
      expect(page).to have_link('Page B', href: project_doc_path(@project, doc_b))
    end

    it 'shows backlinks' do
      doc_a = create(:note, project: @project, author: @user, title: 'Page A')
      doc_b = create(:note, project: @project, author: @user, title: 'Page B')
      NoteLink.create!(source_note: doc_a, target_note: doc_b)

      visit project_doc_path(@project, doc_b)
      expect(page).to have_content('Page A')
    end
  end
end
