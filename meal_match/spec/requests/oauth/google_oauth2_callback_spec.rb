require "rails_helper"

RSpec.describe "Google OAuth2 callback", type: :request do
  let(:callback_path) { "/oauth/google_oauth2/callback" }
  let(:expires_at) { 1.hour.from_now.to_i }
  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      provider_account_id: "provider-123",
      info: OmniAuth::AuthHash.new(
        email: "user@example.com",
        first_name: "Test",
        last_name: "User"
      ),
      credentials: OmniAuth::AuthHash.new(
        token: "access-token",
        expires_at: expires_at,
        refresh_token: "refresh-token",
        scope: "email profile",
        token_type: "Bearer"
      )
    )
  end

  let(:omniauth_env) do
    {
      "omniauth.auth" => auth_hash,
      "omniauth.origin" => "http://example.test/login"
    }
  end

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  it "creates a new user and user account, then redirects to the dashboard" do
    expect do
      get callback_path, env: omniauth_env
    end.to change(User, :count).by(1).and change(UserAccount, :count).by(1)

    expect(response).to redirect_to(dashboard_path)

    user = User.last
    account = UserAccount.last

    expect(user.email).to eq("user@example.com")
    expect(user.first_name).to eq("Test")
    expect(user.last_name).to eq("User")

    expect(account.user).to eq(user)
    expect(account.provider).to eq("google_oauth2")
    expect(account.provider_account_id).to eq("provider-123")
    expect(account.access_token).to eq("access-token")
    expect(account.refresh_token).to eq("refresh-token")
    expect(account.scope).to eq("email profile")
    expect(account.token_type).to eq("Bearer")
    expect(account.expires_at.to_i).to eq(Time.at(expires_at).to_i)
  end

  it "updates an existing user and account without creating duplicates" do
    user = User.create!(email: "user@example.com", first_name: "Old", last_name: "Name")
    UserAccount.create!(
      user: user,
      provider: "google_oauth2",
      provider_account_id: "provider-123",
      access_token: "old-token",
      refresh_token: "old-refresh",
      scope: "email",
      expires_at: 1.day.ago
    )
    expect(User.count).to eq(1)
    expect(UserAccount.count).to eq(1)

    get callback_path, env: omniauth_env

    expect(response).to redirect_to(dashboard_path)

    user.reload
    account = UserAccount.find_by!(user: user)

    expect(User.count).to eq(1)
    expect(UserAccount.count).to eq(1)
    expect(user.first_name).to eq("Test")
    expect(user.last_name).to eq("User")
    expect(account.access_token).to eq("access-token")
    expect(account.refresh_token).to eq("refresh-token")
    expect(account.scope).to eq("email profile")
    expect(account.expires_at.to_i).to eq(Time.at(expires_at).to_i)
  end
end
