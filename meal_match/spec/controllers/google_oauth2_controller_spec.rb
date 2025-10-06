require 'rails_helper'

RSpec.describe OAuth::GoogleOauth2Controller, type: :controller do
  describe "GET #callback" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        info: {
          email: 'user@example.com',
          first_name: 'Test',
          last_name: 'User'
        },
        credentials: {
          token: '12345',
          refresh_token: 'abcde',
          expires_at: Time.now.to_i + 3600,
          scope: 'email profile'
        },
        provider_account_id: '9999'
      )
    end

    before do
      request.env['omniauth.auth'] = auth_hash
      request.env['omniauth.origin'] = '/origin'
    end

    it "creates or updates the user and redirects to dashboard" do
      expect {
        get :callback
      }.to change(User, :count).by(1).and change(UserAccount, :count).by(1)

      expect(session[:user_id]).to eq(User.last.id)
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
