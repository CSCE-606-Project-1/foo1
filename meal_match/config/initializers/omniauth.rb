# Initializers in config/initializers are executed in
# rails before the app begins accepting connections.

# This is the initialzer for omniauth, i.e setup omniauth with
# respect to google
# so that users using our app can authenticate using Google
Rails.application.config.middleware.use OmniAuth::Builder do
  # Modifying the global OmniAuth config, the callback url prefix
  # is changed from default auth -> oauth.
  #
  # i.e now instead of default callback /auth/google_oauth2/callback
  # the callback URl would be /oauth/google_oauth2/callback
  configure do |config|
    config.path_prefix = "/oauth"
    config.logger = Rails.logger if Rails.env.development?
  end

  # Call provider with 4 arguments
  provider :google_oauth2,
    Rails.application.credentials.dig(:google, :client_id),
    Rails.application.credentials.dig(:google, :client_secret),
    {
      include_granted_scopes: true,

      # email, profile are required, offline is for access token
      # which according to tutorial expires every hour, so in background
      # our app can request for a new one. (TODO: Not really sure if we
      # need offline, but kept it just in case)
      scope: "email, profile, offline"
    }
end
