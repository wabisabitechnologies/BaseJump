class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def show
    @user = User.find(params[:id])
    @projects = @user.projects.includes(:todo_lists)
    @assigned_todos = @user.assigned_todos.includes(todo_list: :project).not_done.limit(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.company_name = params[:user][:company_name]

    if @user.save
      # Create company if company_name is provided
      if params[:user][:company_name].present?
        company = Company.create!(name: params[:user][:company_name])
        @user.update(company: company)
      end

      # Create Company HQ project
      company_hq = @user.company&.projects&.create!(
        name: "Company HQ",
        description: "Welcome to your company!",
        project_type: "company",
        admin: @user
      )
      
      if company_hq
        UserProject.create(user: @user, project: company_hq)
      end

      login!(@user)
      redirect_to home_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :avatar_url, :job_title)
  end
end
