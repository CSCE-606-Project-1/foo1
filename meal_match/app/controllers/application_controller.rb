# Central application controller: global filters and controller-level helpers
# shared by all controllers in the application.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_login

  # Ensure a user is logged in. If there is no `current_user` this method
  # redirects to the login page and sets a flash alert.
  #
  # @return [void]
  def require_login
    unless current_user
      # alert: "..." is equivalent to setting the flash
      # with key :alert before redirect i.e.
      # flash[:alert] = "..."
      redirect_to login_path, alert: "Login Required !"
    end
  end

  # Expose the currently authenticated user to controllers and views.
  #
  # @return [User, nil]
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
