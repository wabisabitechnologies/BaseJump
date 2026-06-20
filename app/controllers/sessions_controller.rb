class SessionsController < ApplicationController
  def new
    render plain: 'Login form'
  end

  def create
    user = User.find_by_credentials(
      params[:session][:username_or_email],
      params[:session][:password]
    )

    if user
      user.reset_session_token!
      login!(user)
      redirect_to '/home', notice: 'Logged in successfully!'
    else
      render plain: 'Invalid credentials', status: :unprocessable_entity
    end
  end

  def destroy
    current_user&.reset_session_token!
    logout!
    redirect_to '/', notice: 'Logged out successfully!'
  end
end