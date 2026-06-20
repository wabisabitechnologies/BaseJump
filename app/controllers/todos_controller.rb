class TodosController < ApplicationController
  before_action :require_login

  def create
    @todo = Todo.new(todo_params)
    @todo.author = current_user

    if @todo.save
      respond_to do |format|
        format.html { redirect_back(fallback_location: home_path) }
        format.turbo_stream
      end
    else
      render turbo_stream: 'error'
    end
  end

  def toggle
    @todo = Todo.find(params[:id])
    @todo.update(done: !@todo.done)

    respond_to do |format|
      format.html { redirect_back(fallback_location: home_path) }
      format.turbo_stream
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :todo_list_id, :due_date)
  end
end