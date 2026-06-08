class PagesController < ApplicationController
  before_action :require_login

  def home
    @projects = current_user.projects.includes(:users)
    @company_hq = @projects.find { |p| p.project_type == 'company' }
    @teams = @projects.select { |p| p.project_type == 'team' }
    @other_projects = @projects.select { |p| p.project_type == 'project' }
  end
end