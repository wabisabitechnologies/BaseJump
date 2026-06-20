require 'test_helper'

class CommentTest < ActiveSupport::TestCase
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
    @todo_list = TodoList.create!(title: 'Test List', project: @project, author: @user)
  end

  test 'valid comment' do
    comment = Comment.new(
      body: 'Test comment',
      author: @user,
      commentable: @todo_list
    )
    assert comment.valid?
  end

  test 'requires body' do
    comment = Comment.new(
      author: @user,
      commentable: @todo_list
    )
    assert_not comment.valid?
  end

  test 'polymorphic association works' do
    todo = Todo.create!(title: 'Test', author: @user)
    comment = Comment.create!(
      body: 'Todo comment',
      author: @user,
      commentable: todo
    )
    assert_equal todo, comment.commentable
  end
end