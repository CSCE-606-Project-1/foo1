require "rails_helper"
require "nokogiri"

RSpec.describe "Viewing an ingredient list", type: :request do
  let(:user) do
    User.create!(email: "viewer@example.com", first_name: "View", last_name: "Er")
  end

  let!(:ingredient) do
    Ingredient.create!(
      provider_name: Ingredient::THEMEALDB_PROVIDER,
      provider_id: "77",
      title: "Cheese"
    )
  end

  let!(:ingredient_list) do
    list = IngredientList.create!(user: user, title: "Brunch")
    list.ingredients << ingredient
    list
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "prefills the list title and selected ingredients in the modal" do
    get ingredient_list_path(ingredient_list)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('value="Brunch"')
    expect(response.body).to include('data-ingredient-search-preselected-value')

    doc = Nokogiri::HTML(response.body)
    data = doc.at_css('[data-controller="ingredient-search"]')
    expect(data).to be_present
    raw_value = data["data-ingredient-search-preselected-value"]
    expect(raw_value).to be_present
    parsed = JSON.parse(raw_value)
    expect(parsed).to include(a_hash_including("id" => "77", "name" => "Cheese"))
  end
end
