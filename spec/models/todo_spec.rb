require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      todo = Todo.new(author_id: create(:user).id)
      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end

    it 'validates presence of author_id' do
      todo = Todo.new(title: 'Test')
      expect(todo).not_to be_valid
      expect(todo.errors[:author_id]).to include("can't be blank")
    end

    it 'validates done inclusion' do
      todo = build(:todo)
      expect(todo.done).to eq(false)
    end
  end

  describe 'associations' do
    it 'belongs to author' do
      todo = create(:todo)
      expect(todo.author).to be_a(User)
    end

    it 'has many user_todos' do
      todo = create(:todo)
      user = create(:user)
      UserTodo.create(user: user, todo: todo)
      expect(todo.user_todos.count).to eq(1)
    end

    it 'has many assignees through user_todos' do
      todo = create(:todo)
      user = create(:user)
      UserTodo.create(user: user, todo: todo)
      expect(todo.assignees).to include(user)
    end

    it 'has many taggings' do
      todo = create(:todo)
      tag = create(:tag)
      Tagging.create(tag: tag, taggable: todo)
      expect(todo.taggings.count).to eq(1)
    end
  end

  describe 'scopes' do
    let!(:list) { create(:todo_list) }
    let!(:loose_todo) { create(:todo, :loose) }
    let!(:done_todo) { create(:todo, :done, todo_list: list) }
    let!(:pending_todo) { create(:todo, todo_list: list) }

    it 'returns loose todos' do
      expect(Todo.loose).to include(loose_todo)
      expect(Todo.loose).not_to include(pending_todo)
    end

    it 'returns done todos' do
      expect(Todo.done).to include(done_todo)
      expect(Todo.done).not_to include(pending_todo)
    end

    it 'returns not done todos' do
      expect(Todo.not_done).to include(pending_todo, loose_todo)
      expect(Todo.not_done).not_to include(done_todo)
    end
  end

  describe '#toggle_status' do
    it 'toggles done status' do
      todo = create(:todo, done: false)
      todo.toggle_status
      expect(todo.reload.done).to be true
      todo.toggle_status
      expect(todo.reload.done).to be false
    end
  end

  describe '#loose?' do
    it 'returns true when no todo_list' do
      todo = create(:todo, :loose)
      expect(todo.loose?).to be true
    end

    it 'returns false when has todo_list' do
      todo = create(:todo, :with_list)
      expect(todo.loose?).to be false
    end
  end

  describe 'pg_search' do
    it 'searches by title' do
      todo = create(:todo, title: 'Buy groceries')
      create(:todo, title: 'Walk the dog')

      results = Todo.search('groceries')
      expect(results).to include(todo)
    end
  end
end
