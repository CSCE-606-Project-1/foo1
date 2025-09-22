require 'rails_helper'

RSpec.describe "RecipeSearches", type: :request do
  let!(:user) { User.create!(email: "test@example.com", first_name: "Test", last_name: "User") }
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /new" do
    it "renders the new template" do
      get new_recipe_search_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Enter ingredients")
    end
  end

  describe "POST /recipe_searches" do
    let(:valid_params) { { recipe_search: { ingredients: "chicken_breast" } } }

    it "creates a new RecipeSearch and redirects" do
      expect {
        post recipe_searches_path, params: valid_params
      }.to change(RecipeSearch, :count).by(1)
      expect(response).to redirect_to(RecipeSearch.last)
    end
  end

  describe "GET /recipe_searches/:id" do
    let!(:search) { RecipeSearch.create!(ingredients: "chicken_breast") }

    before do
      # Stub external API
      stub_request(:get, %r{https://www.themealdb.com/api/json/v1/1/filter.php})
        .to_return(
          status: 200,
          body: {
            meals: [
              { strMeal: "Mock Meal", strMealThumb: "http://example.com/mock.jpg", idMeal: "12345" }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it "calls the API and displays meal results" do
      get recipe_search_path(search)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Mock Meal")
      expect(response.body).to include("http://example.com/mock.jpg")
    end
  end
end
