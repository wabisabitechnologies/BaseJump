class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    company = Company.create!(name: params[:user][:company_name] || params[:user][:name])
    @user = User.new(user_params.merge(company: company))

    if @user.save
      Project.create!(
        name: 'Company HQ',
        project_type: 'company',
        admin: @user,
        company: company
      )
      UserProject.create!(user: @user, project: company.projects.first)

      login!(@user)
      redirect_to home_path, notice: 'Welcome! Your account has been created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :job_title, :company_name)
  end
end