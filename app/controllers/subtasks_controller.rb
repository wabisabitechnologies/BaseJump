class SubtasksController < ApplicationController
  before_action :require_login

  def create
    @todo = Todo.find(params[:todo_id])
    @subtask = @todo.subtasks.create(subtask_params.merge(author: current_user))
    redirect_back(fallback_location: home_path)
  end

  def update
    @subtask = Subtask.find(params[:id])
    @subtask.update(subtask_params)
    redirect_back(fallback_location: home_path)
  end

  def destroy
    @subtask = Subtask.find(params[:id])
    @subtask.destroy
    redirect_back(fallback_location: home_path)
  end

  private

  def subtask_params
    params.require(:subtask).permit(:title, :done)
  end
end