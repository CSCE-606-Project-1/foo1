# # spec/requests/recipe_search_spec.rb
# require 'rails_helper'

# RSpec.describe "RecipeSearches", type: :request do
#   let!(:user) { User.create!(email: "test@example.com", first_name: "Test", last_name: "User") }
#   let!(:ingredient1) { Ingredient.create!(provider_name: "mealdb", provider_id: "1", title: "Chicken Breast") }
#   let!(:ingredient2) { Ingredient.create!(provider_name: "mealdb", provider_id: "2", title: "Chole") }
#   let!(:ingredient_list) { IngredientList.create!(user: user, title: "Protein List") }

#   before do
#     # Ensure ingredient list items exist
#     IngredientListItem.create!(ingredient_list: ingredient_list, ingredient: ingredient1)

#     # Stub current_user for all requests
#     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

#     # Stub external API requests
#     stub_request(:get, %r{https://www.themealdb.com/api/json/v1/1/filter.php})
#       .to_return(
#         status: 200,
#         body: {
#           meals: [
#             { strMeal: "Mock Meal", strMealThumb: "http://example.com/mock.jpg", idMeal: "12345" }
#           ]
#         }.to_json,
#         headers: { 'Content-Type' => 'application/json' }
#       )
#   end

#   describe "GET /new" do
#     it "renders the new template with ingredient list dropdown" do
#       get new_recipe_search_path
#       expect(response).to have_http_status(:success)
#       expect(response.body).to include("Enter ingredients")
#       expect(response.body).to include("Or choose an Ingredient List")
#       expect(response.body).to include("Protein List")
#     end
#   end

#   describe "POST /recipe_searches" do
#     it "creates a RecipeSearch using ingredient list" do
#       expect {
#         post recipe_searches_path, params: { recipe_search: { ingredient_list_id: ingredient_list.id } }
#       }.to change(RecipeSearch, :count).by(1)
#       expect(RecipeSearch.last.ingredient_list).to eq(ingredient_list)
#       expect(response).to redirect_to(RecipeSearch.last)
#     end

#     it "creates a RecipeSearch using raw ingredients" do
#       expect {
#         post recipe_searches_path, params: { recipe_search: { ingredients: "Chicken Breast, Chole" } }
#       }.to change(RecipeSearch, :count).by(1)
#       expect(RecipeSearch.last.ingredients).to eq("Chicken Breast, Chole")
#     end
#   end

#   describe "GET /recipe_searches/:id" do
#     let!(:search_with_list) { RecipeSearch.create!(ingredient_list: ingredient_list) }
#     let!(:search_with_ingredients) { RecipeSearch.create!(ingredients: "Chicken Breast, Chole") }

#     it "shows meals for ingredient list" do
#       get recipe_search_path(search_with_list)
#       expect(response.body).to include("Mock Meal")
#       expect(response.body).to include("http://example.com/mock.jpg")
#     end

#     it "shows meals for raw ingredients" do
#       get recipe_search_path(search_with_ingredients)
#       expect(response.body).to include("Mock Meal")
#       expect(response.body).to include("http://example.com/mock.jpg")
#     end
#   end
# end
require 'rails_helper'

RSpec.describe RecipeSearch, type: :model do
  it { should belong_to(:ingredient_list).optional }

  it "can store raw ingredients" do
    search = RecipeSearch.new(ingredients: "Chicken, Chole")
    expect(search.ingredients).to eq("Chicken, Chole")
  end

  it "can store ingredient_list" do
    user = User.create!(email: "test@example.com")
    list = IngredientList.create!(user: user, title: "Protein List")
    search = RecipeSearch.new(ingredient_list: list)
    expect(search.ingredient_list).to eq(list)
  end
end
