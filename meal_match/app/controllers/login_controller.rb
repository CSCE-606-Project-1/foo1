# Controller responsible for rendering the login page and logging out
# users. Authentication is handled by the OAuth callback controller.
class LoginController < ApplicationController
  # Don't need login to login !
  skip_before_action :require_login

  # Corresponds to GET /login, i.e the view
  # rendered after this call completes should show the login
  # page
  #
  # @return [void]
  def new
  end

  # There is no POST /login since the login button should redirect
  # to the URL for google auth -> finally leading to our google oauth
  # callback we defined (after authentication)

  # Corresponds to DELETE /logout
  #
  # Destroys the current session's user id causing the user to be logged out.
  #
  # @return [void]
  def destroy
    # session is a global thing that ruby provides
    session.delete(:user_id)
    flash[:notice] = "Logged out successfully"
    redirect_to root_path
  end
end
