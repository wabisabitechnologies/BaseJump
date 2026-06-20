require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def setup
    @company = Company.create!(name: 'Test Company')
    @user = User.create!(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
    @project = Project.new(
      name: 'Test Project',
      project_type: 'project',
      admin: @user,
      company: @company
    )
  end

  test 'valid project' do
    assert @project.valid?
  end

  test 'requires name' do
    @project.name = nil
    assert_not @project.valid?
  end

  test 'validates project_type inclusion' do
    @project.project_type = 'invalid'
    assert_not @project.valid?
  end

  test 'scopes company_hq' do
    Project.create!(name: 'Company HQ', project_type: 'company', admin: @user, company: @company)
    Project.create!(name: 'Other', project_type: 'project', admin: @user, company: @company)
    assert_equal 1, Project.company_hq.count
  end
end