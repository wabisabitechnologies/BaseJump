class SessionsController < ApplicationController
  RATE_LIMIT_WINDOW = 15.minutes
  MAX_ATTEMPTS = 5

  def new
    render :new
  end

  def create
    username_or_email = params[:session][:username_or_email]
    
    # Simple rate limiting: check failed attempts in session
    rate_limit_key = "login_attempts_#{username_or_email}"
    attempts = session[rate_limit_key] || { count: 0, last_attempt: nil }
    
    # Reset if window has passed
    if attempts[:last_attempt] && attempts[:last_attempt] < RATE_LIMIT_WINDOW.ago
      attempts = { count: 0, last_attempt: nil }
    end
    
    # Check rate limit
    if attempts[:count] >= MAX_ATTEMPTS
      render plain: 'Too many login attempts. Please try again later.', status: :too_many_requests
      return
    end

    user = User.find_by_credentials(
      username_or_email,
      params[:session][:password]
    )

    if user
      # Clear rate limit on successful login
      session.delete(rate_limit_key)
      user.reset_session_token!
      login!(user)
      redirect_to '/home', notice: 'Logged in successfully!'
    else
      # Increment failed attempts
      attempts[:count] += 1
      attempts[:last_attempt] = Time.current
      session[rate_limit_key] = attempts
      
      render plain: 'Invalid credentials', status: :unprocessable_entity
    end
  end

  def destroy
    current_user&.reset_session_token!
    logout!
    redirect_to '/', notice: 'Logged out successfully!'
  end
end