# Request spec for recipes search endpoints.
# Verifies GET /recipes/ingredient_lists/:ingredient_list_id returns HTML and JSON,
# and that controllers correctly use MealDbClient to render search results.
#
# @param format [Symbol] example placeholder (:html or :json)
# @return [void] examples assert HTTP status, HTML content and JSON payloads
# def to_format(format = :html)
#   # format the request spec description (example placeholder for YARD)
# end
#
require 'rails_helper'

RSpec.describe 'Recipes search', type: :request do
  describe 'GET /recipes/ingredient_lists/:ingredient_list_id' do
  let(:user) { User.create!(email: 'test@example.com', first_name: 'Test', last_name: 'User') }
    let(:ingredient1) { Ingredient.create!(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: '1', title: 'Chicken') }
    let(:ingredient2) { Ingredient.create!(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: '2', title: 'Onion') }
    let(:ingredient_list) { IngredientList.create!(user: user, title: 'My List') }

    before do
      ingredient_list.ingredient_list_items.create!(ingredient: ingredient1)
      ingredient_list.ingredient_list_items.create!(ingredient: ingredient2)
      # stub current_user to avoid authentication redirects
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'renders search results using MealDbClient' do
      stubbed = [ { id: '1234', name: 'Stub Meal', thumb: 'https://example.com/thumb.jpg' } ]
      allow(MealDbClient).to receive(:filter_by_ingredients).and_return(stubbed)

      get "/recipes/ingredient_lists/#{ingredient_list.id}", params: { ingredient_list_id: ingredient_list.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Recipes for')
      expect(response.body).to include('Stub Meal')
    end

    it 'returns json when requested' do
      stubbed = [ { id: '1234', name: 'Stub Meal', thumb: 'https://example.com/thumb.jpg' } ]
      allow(MealDbClient).to receive(:filter_by_ingredients).and_return(stubbed)

      get "/recipes/ingredient_lists/#{ingredient_list.id}", params: { ingredient_list_id: ingredient_list.id }, headers: { 'ACCEPT' => 'application/json' }

      expect(response).to have_http_status(:ok)
  json = JSON.parse(response.body)
  expect(json).to be_a(Hash)
  expect(json['recipes']).to be_an(Array)
  expect(json['recipes'].first['name']).to eq('Stub Meal')
    end
  end
end
