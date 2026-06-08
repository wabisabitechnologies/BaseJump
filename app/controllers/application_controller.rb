class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?, :current_company

  private

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    current_user.present?
  end

  def current_company
    @current_company ||= current_user&.company
  end

  def require_login
    unless logged_in?
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'Please log in to continue' }
        format.turbo_stream { redirect_to root_path, alert: 'Please log in to continue' }
      end
    end
  end

  def login!(user)
    session[:session_token] = user.session_token
    @current_user = user
    @current_company = user.company
  end

  def logout!
    session.delete(:session_token)
    @current_user = nil
    @current_company = nil
  end
end
