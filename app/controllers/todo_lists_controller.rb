class TodoListsController < ApplicationController
  before_action :require_login

  def index
    @project = Project.find(params[:project_id])
    @todo_lists = @project.todo_lists.includes(:todos, :author)
  end

  def show
    @todo_list = TodoList.find(params[:id])
    @todos = @todo_list.todos.includes(:assignees)
    @loose_todos = Todo.where(todo_list_id: nil, author: current_user)
  end
end