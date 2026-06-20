require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  def setup
    @company = Company.create!(name: 'Test Company')
    @user = User.create!(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
  end

  test 'valid todo' do
    todo = Todo.new(title: 'Test Todo', author: @user)
    assert todo.valid?
  end

  test 'requires title' do
    todo = Todo.new(author: @user)
    assert_not todo.valid?
  end

  test 'toggle_status' do
    todo = Todo.create!(title: 'Test', author: @user, done: false)
    todo.toggle_status
    assert todo.reload.done?
  end
end