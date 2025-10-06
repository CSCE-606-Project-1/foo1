# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:user) { User.create!(email: "test@example.com") }
  let(:list) { user.ingredient_lists.create!(title: "My List") }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #search" do
    context "when ingredient_list_id is nil or blank" do
      it "redirects to dashboard and sets alert when ingredient_list_id is blank" do
        get :search, params: { ingredient_list_id: "" }
        expect(flash[:alert]).to include("does not exist")
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when ingredient_list does not exist" do
      it "redirects to dashboard with alert" do
        get :search, params: { ingredient_list_id: 999 }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "with valid ingredient list" do
      before do
        allow(MealDbClient)
          .to receive(:filter_by_ingredients)
          .and_return([ { id: "1", name: "Soup", thumb: "img.png" } ])
      end

      it "assigns @recipes and renders HTML" do
        get :search, params: { ingredient_list_id: list.id }
        expect(assigns(:recipes)).to be_present
        expect(response).to render_template(:search)
      end

      it "renders JSON when requested" do
        get :search, params: { ingredient_list_id: list.id }, format: :json
        parsed = JSON.parse(response.body)
        expect(parsed["recipes"].first["name"]).to eq("Soup")
      end
    end
  end

  describe "GET #search_intermediate" do
    context "when no ingredient_list_id is given" do
      it "redirects to dashboard" do
        get :search_intermediate
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when ingredient_list not found" do
      it "redirects to dashboard" do
        get :search_intermediate, params: { ingredient_list_id: 999 }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when valid id provided" do
      it "redirects to ingredient_list_recipe_path" do
        get :search_intermediate, params: { ingredient_list_id: list.id }
        expect(response).to redirect_to(ingredient_list_recipe_path(id: list.id))
      end
    end
  end
end
