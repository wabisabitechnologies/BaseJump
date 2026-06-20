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
    @todo = @todo_list.todos.new
  end

  def create
    @project = Project.find(params[:project_id])
    @todo_list = @project.todo_lists.new(todo_list_params)
    @todo_list.author = current_user

    if @todo_list.save
      redirect_to [@project, @todo_list], notice: "Todo list created."
    else
      @todo_lists = @project.todo_lists.includes(:todos, :author)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end
end
