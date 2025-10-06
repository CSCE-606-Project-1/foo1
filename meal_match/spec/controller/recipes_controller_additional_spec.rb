# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:user) { User.create!(email: "spec@example.com") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #search" do
    it "redirects to dashboard and sets alert when ingredient_list_id is nil" do
      get :search, params: { ingredient_list_id: "" }
      expect(flash[:alert]).to include("does not exist")
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to dashboard and sets alert when ingredient list not found" do
      get :search, params: { ingredient_list_id: "999999" }
      expect(flash[:alert]).to include("does not exist")
      expect(response).to redirect_to(dashboard_path)
    end

    it "handles MealDbClient errors gracefully and renders html with empty recipes" do
      list = IngredientList.create!(user: user, title: "L")
      allow(IngredientList).to receive(:find_by).with(id: list.id.to_s).and_return(list)
      allow(MealDbClient).to receive(:filter_by_ingredients).and_raise(StandardError)

      get :search, params: { ingredient_list_id: list.id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:recipes)).to eq([])
      expect(flash.now[:alert]).to include("Error fetching recipes")
      expect(response).to render_template(:search)
    end

    it "returns json payload when json requested" do
      list = IngredientList.create!(user: user, title: "L2")
      allow(IngredientList).to receive(:find_by).with(id: list.id.to_s).and_return(list)
      allow(MealDbClient).to receive(:filter_by_ingredients).and_return([ { id: "1", name: "X" } ])

      get :search, params: { ingredient_list_id: list.id }, format: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["recipes"]).to be_an(Array)
      expect(json["recipes"].first["name"] || json["recipes"].first["id"]).not_to be_nil
    end
  end

  describe "GET #search_intermediate" do
    it "redirects when ingredient_list_id blank" do
      get :search_intermediate, params: { ingredient_list_id: "" }
      expect(flash[:alert]).to include("Please select an ingredient list")
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to recipe search when ingredient_list exists" do
      list = IngredientList.create!(user: user, title: "L3")
      get :search_intermediate, params: { ingredient_list_id: list.id }
      expect(response).to redirect_to(ingredient_list_recipe_path(id: list.id))
    end
  end
end
