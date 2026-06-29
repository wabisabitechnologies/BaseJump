require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }
  let(:todo_list) { create(:todo_list, project: project, author: user) }

  before { login_as(user) }

  describe 'POST /todos (create todo)' do
    it 'creates a todo with valid params' do
      expect {
        post todos_path, params: { todo: { title: 'New Todo', todo_list_id: todo_list.id } }, as: :turbo_stream
      }.to change(Todo, :count).by(1)
      expect(response).to have_http_status(:ok)
    end

    it 'creates a loose todo' do
      expect {
        post todos_path, params: { todo: { title: 'Loose Todo' } }, as: :turbo_stream
      }.to change(Todo, :count).by(1)
      expect(Todo.last.todo_list_id).to be_nil
    end

    it 'rejects todo without title' do
      post todos_path, params: { todo: { title: '' } }, as: :turbo_stream
      expect(response).to have_http_status(:ok) # turbo_stream error
    end
  end

  describe 'PATCH /todos/:id/toggle (toggle todo)' do
    let!(:todo) { create(:todo, author: user, todo_list: todo_list, done: false) }

    it 'toggles done status' do
      patch toggle_todo_path(todo), as: :turbo_stream
      expect(todo.reload.done).to be true
    end

    it 'toggles back to not done' do
      todo.update(done: true)
      patch toggle_todo_path(todo), as: :turbo_stream
      expect(todo.reload.done).to be false
    end
  end
end
