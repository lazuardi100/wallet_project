class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_authentication, unless: :sessions_controller?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  private
  def check_authentication
    unless session[:user_id].present?
      flash[:error] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def sessions_controller?
    self.class == SessionsController
  end
end
