# Controller spec for IngredientListRecipesController#show.
# Verifies that the controller queries TheMealDB filter/lookup endpoints,
# builds @meals for the view, and redirects when the ingredient list is absent
# or does not belong to the current_user.
#
# @param format [Symbol] example placeholder
# @return [void] examples assert API stubbing, @meals assignment and access control
# def to_format(format = :html)
#   # format the ingredient-list controller spec description (example placeholder for YARD)
# end
#
require "rails_helper"

RSpec.describe IngredientListRecipesController, type: :controller do
  let(:user) { User.create!(email: "test@example.com") }
  let(:list) { user.ingredient_lists.create!(title: "My List") }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "GET #show" do
    context "when ingredient list exists with ingredients" do
      before do
        list.ingredients.create!(provider_name: "themealdb", provider_id: "10", title: "Chicken")
      end

      it "queries TheMealDB API and assigns meals" do
        api_key = "123"
        allow(ENV).to receive(:[]).with("THEMEALDB_API_KEY").and_return(api_key)

        stub_request(:get, %r{filter.php\?i=Chicken}).to_return(
          body: { meals: [ { "idMeal" => "111", "strMeal" => "Soup" } ] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        stub_request(:get, %r{lookup.php\?i=111}).to_return(
          body: { meals: [ { "idMeal" => "111", "strMeal" => "Soup", "strInstructions" => "Boil water" } ] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        get :show, params: { id: list.id }
        expect(assigns(:meals)).to be_an(Array)
        expect(assigns(:meals).first["strMeal"]).to eq("Soup")
      end
    end

    context "when ingredient list has no ingredients" do
      it "assigns empty meals" do
        get :show, params: { id: list.id }
        expect(assigns(:meals)).to eq([])
      end
    end

    context "when ingredient list does not belong to user" do
      it "redirects to dashboard" do
        other_user = User.create!(email: "other@example.com")
        other_list = other_user.ingredient_lists.create!(title: "Other")
        get :show, params: { id: other_list.id }
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
