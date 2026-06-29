require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      project = Project.new(project_type: 'project')
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'validates project_type inclusion' do
      project = build(:project, project_type: 'invalid')
      expect(project).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to company' do
      project = create(:project)
      expect(project.company).to be_a(Company)
    end

    it 'has many users through user_projects' do
      project = create(:project)
      user = create(:user, company: project.company)
      UserProject.create(user: user, project: project)
      expect(project.users).to include(user)
    end

    it 'has many todo_lists' do
      project = create(:project)
      todo_list = create(:todo_list, project: project)
      expect(project.todo_lists).to include(todo_list)
    end

    it 'has many messages' do
      project = create(:project)
      message = create(:message, project: project)
      expect(project.messages).to include(message)
    end

    it 'has many events' do
      project = create(:project)
      event = create(:event, project: project)
      expect(project.events).to include(event)
    end
  end

  describe 'templates' do
    it 'can be marked as template' do
      template = create(:project, :with_template)
      expect(template.is_template).to be true
    end

    it 'defaults to non-template' do
      project = create(:project)
      expect(project.is_template).to be false
    end
  end
end
