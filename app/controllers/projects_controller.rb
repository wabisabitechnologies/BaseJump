class ProjectsController < ApplicationController
  before_action :require_login

  def show
    @project = Project.find(params[:id])
    @todo_lists = @project.todo_lists.includes(:todos, :author)
  end
end
