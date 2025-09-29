require "rails_helper"

RSpec.describe "IngredientListManager", type: :request do
  let(:user) do
    User.new(email: "solidsnake@gmail.com",
             first_name: "Solid",
             last_name: "Snake")
  end

  let(:title_1) { "List 1" }
  let(:title_2) { "List 2" }

  before do
    # bypasses login
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "shows all ingredient lists created by the user in one place" do
    IngredientList.create!(user: user, title: title_1)
    IngredientList.create!(user: user, title: title_2)

    get "/ingredient_lists"
    expect(response).to have_http_status(:ok)

    # Check that all ingredient lists created by user are visible on
    # the page.
    expect(response.body).to include(title_1)
    expect(response.body).to include(title_2)
  end
end
