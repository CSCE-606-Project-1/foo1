require "rails_helper"
require "nokogiri"

RSpec.describe "Ingredient list no-JS fallback", type: :request do
  let(:user) do
    User.create!(email: "nojs@example.com", first_name: "No", last_name: "Js")
  end

  let!(:ingredient_list) do
    IngredientList.create!(user: user, title: "Soup Night")
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "includes the noscript fallback editor" do
    get ingredient_list_path(ingredient_list)

    expect(response.body).to include("no-js-editor")
    expect(response.body).to include("Manage Ingredient List")

    doc = Nokogiri::HTML(response.body)
    noscript = doc.at_css("noscript")
    expect(noscript).to be_present
    expect(noscript.to_s).to include(".js-only { display: none !important; }")
  end

  it "preserves selected ingredients across HTML searches" do
    allow(MealDbClient).to receive(:search_ingredients).with("tomato").and_return([
      { id: "10", name: "Tomato" },
      { id: "20", name: "Cherry Tomato" }
    ])

    allow(MealDbClient).to receive(:fetch_all_ingredients).and_return([
      { id: "10", name: "Tomato" },
      { id: "20", name: "Cherry Tomato" }
    ])

    get ingredient_search_path(format: :html), params: {
      q: "tomato",
      ingredient_list_id: ingredient_list.id,
      ingredient_list: {
        selected_ingredient_ids: ["10"]
      }
    }

    expect(response).to have_http_status(:ok)

    doc = Nokogiri::HTML(response.body)
    noscript = doc.at_css("noscript")
    fragment = Nokogiri::HTML.fragment(noscript&.inner_html.to_s)
    checkbox = fragment.at_css('input[name="ingredient_list[selected_ingredient_ids][]"][value="10"]')
    expect(checkbox).to be_present
    expect(checkbox["checked"]).to be_present
  end

  it "keeps the entered title when searching without JS" do
    allow(MealDbClient).to receive(:search_ingredients).with("basil").and_return([
      { id: "30", name: "Basil" }
    ])

    get ingredient_search_path(format: :html), params: {
      q: "basil",
      ingredient_list_id: ingredient_list.id,
      ingredient_list: {
        title: "Soup Night Revised"
      }
    }

    expect(response).to have_http_status(:ok)

    doc = Nokogiri::HTML(response.body)
    expect(doc.at_css('#ingredient-list-name')["value"]).to eq("Soup Night Revised")

    noscript = doc.at_css("noscript")
    fragment = Nokogiri::HTML.fragment(noscript&.inner_html.to_s)
    fallback_input = fragment.at_css('input[name="ingredient_list[title]"]')
    expect(fallback_input).to be_present
    expect(fallback_input["value"]).to eq("Soup Night Revised")
  end
end
