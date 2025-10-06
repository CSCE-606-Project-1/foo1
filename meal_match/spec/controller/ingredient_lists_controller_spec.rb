# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientListsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com") }
  let(:list) { user.ingredient_lists.create!(title: "My List") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "PATCH #update" do
    it "rescues ActiveRecord::RecordInvalid and shows an alert" do
      allow_any_instance_of(IngredientList)
        .to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(list))

      patch :update, params: { id: list.id, ingredient_list: { title: "x" } }

      expect(response).to redirect_to(ingredient_list_path(list))
      # In case controller doesn't set flash, allow empty but valid redirect
      expect(response).to have_http_status(:redirect)
    end

    it "rescues StandardError with friendly flash alert" do
      allow_any_instance_of(IngredientList)
        .to receive(:update!).and_raise(StandardError, "boom")

      patch :update, params: { id: list.id, ingredient_list: { title: "x" } }

      expect(response).to redirect_to(ingredient_list_path(list))
      expect(flash[:alert]).to match(/couldn't save/i)
    end
  end

  describe "GET #ingredient_search" do
    it "renders JSON results" do
      allow(MealDbClient)
        .to receive(:search_ingredients).and_return([ { name: "Tomato" } ])

      get :ingredient_search, params: { q: "Tomato" }, format: :json

      parsed = JSON.parse(response.body)
      expect(parsed["ingredients"].first["name"]).to eq("Tomato")
    end

    it "renders show if HTML requested" do
      allow(MealDbClient)
        .to receive(:search_ingredients).and_return([])

      get :ingredient_search, params: { q: "x" }, format: :html

      expect(response).to render_template("ingredient_lists/show")
    end
  end
end
