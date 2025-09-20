module OAuth
  class GoogleOauth2Controller < ApplicationController
    # The callback that we have set for user authentication via google,
    # this gets caled after a successful authentication with information
    # about the guy who was authenticated
    def callback
      # authentication payload
      auth = request.env["omniauth.auth"]

      # Origin: The page from which we received this request, in case
      # we want to send the user back
      origin = request.env["omniauth.origin"]

      user = User.find_or_initialize_by(email: auth.info.email)
      user.attributes = {
        first_name: auth.info.first_name,
        last_name: auth.info.last_name
      }
      user.save!

      # Session is a global object provided by ruby to maintain the
      # state of a session, so we are using it in a way to store that
      # a user has logged in
      session[:user_id] = user.id

      # Returns an existing User account if exists or creates
      # a new object (maybe not saveable state) of UserAccount
      # that may need some additional property setting after this
      # creation
      user_account = UserAccount.find_or_initialize_by(
        provider: auth.provider,
        provider_account_id: auth.provider_account_id
      )

      # Set/Update additional attributes of user account before saving
      # Below code is functionally equivalent to writing:
      # user_account.access_token = ...
      # user_account.auth_protocol = ...
      user_account.attributes = {
        access_token: auth.credentials.token,
        auth_protocol: "oauth2",
        expires_at: Time.at(auth.credentials.expires_at).to_datetime,
        refresh_token: auth.credentials.refresh_token,
        scope: auth.credentials.scope,
        token_type: "Bearer",
        # Rails is smart enough to understand that since UserAccount belongs
        # to User object, this indicates the foreign key association
        user: user
      }

      user_account.save!

      redirect_to dashboard_path
    end
  end
end
