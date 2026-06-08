require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @company = Company.create!(name: 'Test Company')
  end

  test 'valid user' do
    user = User.new(
      name: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
    assert user.valid?
  end

  test 'requires email' do
    user = User.new(
      name: 'Test User',
      username: 'testuser',
      password: 'password123',
      company: @company
    )
    assert_not user.valid?
  end

  test 'requires username' do
    user = User.new(
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
      company: @company
    )
    assert_not user.valid?
  end

  test 'requires company' do
    user = User.new(
      name: 'Test User',
      username: 'testuser2',
      email: 'test2@example.com',
      password: 'password123'
    )
    assert_not user.valid?
  end

  test 'password minimum length' do
    user = User.new(
      name: 'Test User',
      username: 'testuser3',
      email: 'test3@example.com',
      password: '12345',
      company: @company
    )
    assert_not user.valid?
  end

  test 'normalizes email and username' do
    user = User.new(
      name: 'Test User',
      username: ' TESTUSER ',
      email: ' TEST@EXAMPLE.COM ',
      password: 'password123',
      company: @company
    )
    user.valid?
    assert_equal 'test@example.com', user.email
    assert_equal 'testuser', user.username
  end
end