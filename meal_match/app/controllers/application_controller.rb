class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_login()
    unless current_user
      # alert: "..." is equivalent to setting the flash
      # with key :alert before redirect i.e.
      # flash[:alert] = "..."
      redirect_to login_path, alert: "Login Required !"
    end
  end

  # Helper method makes the controller method available to the views,
  # and since this is in ApplicationController the base class for all
  # the controllers, all of them can directly use current_user when they
  # want to (of courses after a call to require_login() if login is needed
  # for the controller to act)
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
