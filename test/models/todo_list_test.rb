require 'test_helper'

class TodoListTest < ActiveSupport::TestCase
  def setup
    @company = Company.create!(name: 'Test Company')
    @user = User.create!(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
    @project = Project.create!(
      name: 'Test Project',
      project_type: 'project',
      admin: @user,
      company: @company
    )
    @todo_list = TodoList.new(
      title: 'Test List',
      project: @project,
      author: @user
    )
  end

  test 'valid todo_list' do
    assert @todo_list.valid?
  end

  test 'requires title' do
    @todo_list.title = nil
    assert_not @todo_list.valid?
  end

  test 'requires project' do
    @todo_list.project = nil
    assert_not @todo_list.valid?
  end

  test 'progress_percentage for empty list' do
    assert_equal 0, @todo_list.progress_percentage
  end

  test 'progress_percentage with todos' do
    @todo_list.save!
    @todo_list.todos.create!(title: 'Todo 1', done: true, author: @user)
    @todo_list.todos.create!(title: 'Todo 2', done: false, author: @user)
    assert_equal 50, @todo_list.progress_percentage
  end
end