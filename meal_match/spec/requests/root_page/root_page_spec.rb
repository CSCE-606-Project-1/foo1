require "rails_helper"

RSpec.describe "Root Page", type: :request do
  let(:user) do
    User.create!(email: "solidsnake@gmail.com",
                 first_name: "Solid",
                 last_name: "Snake")
  end

  it "redirects the user to the login page if not logged in " do
    # Root -> dashboard -> login
    get root_path
    expect(response).to redirect_to("/dashboard")
    follow_redirect!

    expect(response).to redirect_to("/login")
  end

  it "directs the user to the dashboard if already logged in" do
    # Bypass auth
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    get root_path
    expect(response).to redirect_to("/dashboard")
  end
end
