# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientListRecipesController, type: :controller do
  let(:user) { User.create!(email: "owner@example.com") }
  let(:other) { User.create!(email: "other@example.com") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    it "redirects to dashboard when list not belonging to current_user" do
      other_list = other.ingredient_lists.create!(title: "Other")
      get :show, params: { id: other_list.id }
      expect(response).to redirect_to(dashboard_path)
    end

    it "sets @meals to [] when HTTParty returns non-success response" do
      list = user.ingredient_lists.create!(title: "MyList")
      list.ingredients.create!(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: "1", title: "Chicken")

      fake_response = double("resp", success?: false, body: "{}")
      allow(HTTParty).to receive(:get).and_return(fake_response)

      get :show, params: { id: list.id }
      expect(assigns(:meals)).to eq([])
    end

    it "parses detail fallback when lookup fails and filter succeeds" do
      list = user.ingredient_lists.create!(title: "MyList2")
      list.ingredients.create!(provider_name: Ingredient::THEMEALDB_PROVIDER, provider_id: "2", title: "Onion")

      filter_body = { "meals" => [ { "idMeal" => "42", "strMeal" => "Foo" } ] }.to_json
      filter_resp = double("filter", success?: true, body: filter_body)
      detail_resp = double("detail", success?: false, body: "{}")

      # first HTTParty.get -> filter, second -> lookup
      allow(HTTParty).to receive(:get).and_return(filter_resp, detail_resp)

      get :show, params: { id: list.id }
      expect(assigns(:meals)).to be_an(Array)
      expect(assigns(:meals).first["idMeal"]).to eq("42")
    end
  end
end
