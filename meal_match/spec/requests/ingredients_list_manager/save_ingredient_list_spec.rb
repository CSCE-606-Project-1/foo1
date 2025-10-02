require "rails_helper"

RSpec.describe "Saving ingredient lists", type: :request do
  let(:user) do
    User.create!(email: "user@example.com", first_name: "Test", last_name: "User")
  end

  let!(:ingredient_list) do
    IngredientList.create!(user: user, title: "Untitled list")
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "PATCH /ingredient_lists/:id" do
    before do
      allow(MealDbClient).to receive(:fetch_all_ingredients).and_return([
        { id: "10", name: "Tomato", description: "Red" },
        { id: "20", name: "Basil", description: "Herb" }
      ])
    end

    it "updates the title and selected ingredients, then redirects to index" do
      patch ingredient_list_path(ingredient_list), params: {
        ingredient_list: {
          title: "Dinner Party",
          selected_ingredient_ids: %w[10 20]
        }
      }

      expect(response).to redirect_to(ingredient_lists_path)

      ingredient_list.reload
      expect(ingredient_list.title).to eq("Dinner Party")
      expect(ingredient_list.ingredients.map(&:provider_id)).to contain_exactly("10", "20")

      tomato = Ingredient.find_by(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: "10")
      expect(tomato).to be_present
      expect(tomato.title).to eq("Tomato")
    end

    it "falls back to 'Untitled list' when no title is provided and clears selections" do
      ingredient = Ingredient.create!(
        provider_name: Ingredient::THEMEALDB_PROVIDER,
        provider_id: "99",
        title: "Existing"
      )
      ingredient_list.ingredients << ingredient

      patch ingredient_list_path(ingredient_list), params: {
        ingredient_list: {
          title: " ",
          selected_ingredient_ids: []
        }
      }

      expect(response).to redirect_to(ingredient_lists_path)

      ingredient_list.reload
      expect(ingredient_list.title).to eq("Untitled list")
      expect(ingredient_list.ingredients).to be_empty
    end
  end
end
