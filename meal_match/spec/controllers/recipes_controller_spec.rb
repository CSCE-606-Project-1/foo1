require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  routes { Rails.application.routes }
  let(:user) { User.create!(email: "chef@example.com") }

  before do
    session[:user_id] = user.id
  end

  describe "GET #search" do
    it "redirects with an alert when the ingredient list does not exist" do
      get :search, params: { ingredient_list_id: 999 }

      expect(response).to redirect_to(dashboard_path)
      expect(flash[:alert]).to eq("Ingredient list with list id 999 does not exist")
    end

    it "renders the search template for HTML requests" do
      ingredient = Ingredient.create!(
        provider_name: Ingredient::THEMEALDB_PROVIDER,
        provider_id: "1",
        title: "Chicken"
      )
      list = IngredientList.create!(user: user, title: "Dinner list")
      IngredientListItem.create!(ingredient_list: list, ingredient: ingredient)
      recipes = [
        { id: "10", name: "Chicken Curry", thumb: "thumb.jpg" }
      ]
      expect(MealDbClient).to receive(:filter_by_ingredients).with(["Chicken"]).and_return(recipes)

      get :search, params: { ingredient_list_id: list.id }

      expect(response).to have_http_status(:ok)
      expect(controller.instance_variable_get(:@recipes)).to eq(recipes)
      expect(controller.instance_variable_get(:@ingredient_list)).to eq(list)
    end

    it "renders JSON when requested" do
      ingredient = Ingredient.create!(
        provider_name: Ingredient::THEMEALDB_PROVIDER,
        provider_id: "1",
        title: "Chicken"
      )
      list = IngredientList.create!(user: user, title: "Dinner list")
      IngredientListItem.create!(ingredient_list: list, ingredient: ingredient)
      recipes = [
        { id: "10", name: "Chicken Curry", thumb: "thumb.jpg" }
      ]
      expect(MealDbClient).to receive(:filter_by_ingredients).with(["Chicken"]).and_return(recipes)

      get :search, params: { ingredient_list_id: list.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to eq("recipes" => [
        { "id" => "10", "name" => "Chicken Curry", "thumb" => "thumb.jpg" }
      ])
    end
  end
end
