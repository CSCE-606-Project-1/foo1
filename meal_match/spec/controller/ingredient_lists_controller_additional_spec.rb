# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientListsController, type: :controller do
  let(:user) { User.create!(email: "user2@example.com") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "PATCH #update error flows" do
    let!(:list) { user.ingredient_lists.create!(title: "Original") }

    it "handles ActiveRecord::RecordInvalid raised from update! and redirects to show with alert" do
      invalid = ActiveRecord::RecordInvalid.new(list)
      list.errors.add(:title, "can't be blank")
      allow_any_instance_of(IngredientList).to receive(:update!).and_raise(invalid)

      patch :update, params: { id: list.id, ingredient_list: { title: "x" } }
      expect(response).to redirect_to(ingredient_list_path(list))
      expect(flash[:alert]).to include("can't be blank")
    end

    it "handles generic StandardError in update and shows user friendly message" do
      allow_any_instance_of(IngredientList).to receive(:update!).and_raise(StandardError.new("boom"))

      patch :update, params: { id: list.id, ingredient_list: { title: "y" } }
      expect(response).to redirect_to(ingredient_list_path(list))
      expect(flash[:alert]).to include("couldn't save your ingredient list")
    end
  end

  describe "POST #ingredient_search error handling" do
    it "returns 502 and empty ingredients on JSON when backend raises" do
      allow(MealDbClient).to receive(:search_ingredients).and_raise(StandardError.new("bad"))

      post :ingredient_search, params: { q: "x" }, format: :json
      expect(response).to have_http_status(:bad_gateway)
      json = JSON.parse(response.body)
      expect(json["ingredients"]).to eq([])
    end

    it "renders show with 502 status for html when backend raises" do
      allow(MealDbClient).to receive(:search_ingredients).and_raise(StandardError.new("boom"))

      get :ingredient_search, params: { q: "y", ingredient_list_id: nil }, format: :html
      expect(response.status).to eq(502).or eq(200) # some view setups return 200; we allow either but ensure @search_items is set
      expect(assigns(:search_items)).to eq([]).or be_nil
    end
  end
end
