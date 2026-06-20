class Api::SubtasksController < ApplicationController
  before_action :require_login

  def create
    @subtask = Subtask.new(subtask_params)
    @subtask.author = current_user

    if @subtask.save
      render json: { subtask: subtask_json(@subtask) }, status: 201
    else
      render json: { errors: @subtask.errors.full_messages }, status: 422
    end
  end

  def update
    @subtask = Subtask.find(params[:id])

    if @subtask.update(subtask_params)
      render json: { subtask: subtask_json(@subtask) }
    else
      render json: { errors: @subtask.errors.full_messages }, status: 422
    end
  end

  def destroy
    @subtask = Subtask.find(params[:id])
    @subtask.destroy
    head :no_content
  end

  private

  def subtask_params
    params.require(:subtask).permit(:title, :done, :parent_todo_id)
  end

  def subtask_json(s)
    {
      id: s.id,
      title: s.title,
      done: s.done,
      parent_todo_id: s.parent_todo_id,
      author_id: s.author_id
    }
  end
end
