# Controller spec for SavedRecipesController.
# Tests index, create (valid/invalid) and destroy flows for the current_user's saved recipes,
# asserting DB changes, redirects and flash messages.
#
# @param format [Symbol] example placeholder for response format
# @return [void] examples assert controller assignments, redirects and side-effects
# def to_format(format = :html)
#   # format the controller spec description (example placeholder for YARD)
# end
#
require "rails_helper"

RSpec.describe SavedRecipesController, type: :controller do
  let(:user) { User.create!(email: "test@example.com") }
  let!(:recipe) { user.saved_recipes.create!(meal_id: "1", name: "Salad") }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe "GET #index" do
    it "assigns the user's saved recipes" do
      get :index
      expect(assigns(:saved_recipes)).to eq([ recipe ])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a recipe and redirects back" do
        expect {
          post :create, params: { meal_id: "2", name: "Soup" }
        }.to change(SavedRecipe, :count).by(1)
        expect(response).to be_redirect
      end
    end

    context "with invalid params" do
      it "does not create recipe and sets flash alert" do
        expect {
          post :create, params: { meal_id: nil, name: "Soup" }
        }.not_to change(SavedRecipe, :count)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "removes the saved recipe" do
      expect {
        delete :destroy, params: { id: recipe.id }
      }.to change(SavedRecipe, :count).by(-1)
      expect(response).to redirect_to(saved_recipes_path)
    end
  end
end
