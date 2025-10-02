require "rails_helper"

RSpec.describe "Flash", type: :request do
  let(:user) do
    User.create!(email: "solidsnake@gmail.com",
                 first_name: "Solid",
                 last_name: "Snake")
  end

  it "should display flash alert messages" do
    # Try to access dashboard without logging in
    get "/dashboard"
    expect(response).to have_http_status(:redirect) # expect a redirect

    # Because we try to access dashboard without login, the above
    # request should lead to a redirect to the login page

    # The above get request would respond with the
    # path to redirect to and won't actually redirect,
    # so we ask explicitly to redirect
    follow_redirect!

    # The flash alert message for login successful should be visible on the
    # redirected page
    expect(response.body).to include("Login Required !")
  end

  it "should display flash notice messages" do
    # By pass login
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    # Try to create an ingredient list and successful creation should
    # lead to a redirect to the index page for the ingredient lists (which
    # displays all ingredient lists in one place)
    post "/ingredient_lists"
    expect(response).to have_http_status(:redirect)

    # The above post request would respond with the
    # path to redirect to and won't actually redirect,
    # so we ask explicitly to redirect
    follow_redirect!

    # The flash notice message for list created successfully should get
    # displayed on the page
    expect(response.body).to include("New ingredient list created successfully")
  end
end
