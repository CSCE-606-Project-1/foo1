# Will be only set when the cucumber tests are run
# due to its location in the folder structure, and
# those tests will authenticate via the set mock
# credentials

TEST_USER_UID = '4204201234'
TEST_USER_NAME = 'Solid Snake'
TEST_USER_EMAIL = 'solidsnake@liquid.com'

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: TEST_USER_UID,
  info: {
    name: TEST_USER_NAME,
    email: TEST_USER_EMAIL
  },
  credentials: {
    token: 'mock_token',
    refresh_token: 'mock_refresh_token',
    expires_at: Time.now + 1.week
  }
)
