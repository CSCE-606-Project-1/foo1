require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let(:user) do
    instance_double("User", email: "solidsnake@gmail.com",
                            first_name: "Solid",
                            last_name: "Snake")
  end

  let(:ingredient_list_1) do
     instance_double("IngredientList", id: "1", user: user, title: "List 1")
  end

  let(:ingredient_list_2) do
    instance_double("IngredientList", id: "2", user: user, title: "List 2")
  end

  let(:user_ingredient_lists) { [ ingredient_list_1, ingredient_list_2 ] }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(user).to receive(:ingredient_lists).and_return(user_ingredient_lists)
  end

  it "contains the information of logged in user" do
    get "/dashboard"
    expect(response).to have_http_status(:ok)

    # Check user name and email is present on the dashboard
    expect(response.body).to include("#{user.first_name}")
    expect(response.body).to include("#{user.last_name}")
    expect(response.body).to include("#{user.email}")
  end
end
