# spec/requests/recipes_edge_cases_spec.rb
require "rails_helper"

RSpec.describe "Recipes edge cases", type: :request do
  let(:user) { User.create!(email: "r@example.com", first_name: "R", last_name: "S") }
  let(:list) { IngredientList.create!(user: user, title: "Empty") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "handles empty ingredient list gracefully" do
    allow(MealDbClient).to receive(:filter_by_ingredients).and_return([])
    get "/recipes/ingredient_lists/#{list.id}"
    expect(response.body).to include("No recipes found").or include("Recipes for")
  end

  it "handles MealDbClient errors gracefully" do
    allow(MealDbClient).to receive(:filter_by_ingredients).and_raise(StandardError)
    get "/recipes/ingredient_lists/#{list.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("No recipes found").or include("Recipes for")
  end

  it "returns 406 for unsupported format" do
    get "/recipes/ingredient_lists/#{list.id}", headers: { "ACCEPT" => "application/xml" }
    expect(response).to have_http_status(:not_acceptable)
  end
end
