# Will be only set when the cucumber tests are run
# due to its location in the folder structure, and
# those tests will authenticate via the set mock
# credentials

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: '4204201234',
  info: {
    name: 'Solid Snake',
    email: 'solidsnake@liquid.com'
  },
  credentials: {
    token: 'mock_token',
    refresh_token: 'mock_refresh_token',
    expires_at: Time.now + 1.week
  }
)
