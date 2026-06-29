require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = User.new(username: 'test', email: 'test@test.com', password: 'password123')
      user.company = create(:company)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of username' do
      create(:user, username: 'taken')
      dup = build(:user, username: 'taken')
      expect(dup).not_to be_valid
    end

    it 'validates uniqueness of email' do
      create(:user, email: 'dup@test.com')
      dup = build(:user, email: 'dup@test.com')
      expect(dup).not_to be_valid
    end

    it 'validates password length' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many user_projects' do
      user = create(:user)
      expect(user).to respond_to(:user_projects)
    end

    it 'has many projects through user_projects' do
      user = create(:user)
      project = create(:project, company: user.company)
      UserProject.create(user: user, project: project)
      expect(user.projects).to include(project)
    end

    it 'has many authored_todos' do
      user = create(:user)
      todo = create(:todo, author: user)
      expect(user.authored_todos).to include(todo)
    end

    it 'has many authored_messages' do
      user = create(:user)
      project = create(:project, company: user.company)
      message = create(:message, author: user, project: project)
      expect(user.authored_messages).to include(message)
    end
  end

  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'rejects incorrect password' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end

    it 'finds user by username' do
      expect(User.find_by_credentials(user.username, 'password123')).to eq(user)
    end

    it 'finds user by email' do
      expect(User.find_by_credentials(user.email, 'password123')).to eq(user)
    end

    it 'resets session token' do
      old_token = user.session_token
      user.reset_session_token!
      expect(user.reload.session_token).not_to eq(old_token)
    end
  end

  describe 'normalizes' do
    it 'strips and downcases email' do
      user = create(:user, email: '  TEST@EXAMPLE.COM  ')
      expect(user.email).to eq('test@example.com')
    end

    it 'strips and downcases username' do
      user = create(:user, username: '  TestUser  ')
      expect(user.username).to eq('testuser')
    end
  end

  describe 'avatar' do
    it 'generates default avatar if none provided' do
      user = create(:user, avatar_url: nil)
      expect(user.avatar_url).to include('placehold.co')
    end

    it 'preserves provided avatar' do
      user = create(:user, avatar_url: 'https://example.com/avatar.jpg')
      expect(user.avatar_url).to eq('https://example.com/avatar.jpg')
    end
  end
end
