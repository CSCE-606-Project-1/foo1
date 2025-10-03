require "rails_helper"

RSpec.describe IngredientListsController, type: :controller do
  routes { Rails.application.routes }

  let(:user) { User.create!(email: "tester@example.com") }

  before do
    session[:user_id] = user.id
  end

  describe "POST #create" do
    it "creates a new ingredient list and sets a notice" do
      expect do
        post :create
      end.to change(user.ingredient_lists, :count).by(1)

      expect(flash[:notice]).to eq("New ingredient list created successfully")
      expect(response).to redirect_to(ingredient_lists_path)
    end

    it "sets an alert and redirects when the list cannot be saved" do
      allow_any_instance_of(IngredientList).to receive(:save).and_return(false)
      allow_any_instance_of(IngredientList).to receive_message_chain(:errors, :full_messages).and_return(["Save failed"])

      expect do
        post :create
      end.not_to change(IngredientList, :count)

      expect(flash[:alert]).to eq("Save failed")
      expect(response).to redirect_to(ingredient_lists_path)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the ingredient list when it exists" do
      list = user.ingredient_lists.create!(title: "My List")

      expect do
        delete :destroy, params: { id: list.id }
      end.to change(IngredientList, :count).by(-1)

      expect(flash[:notice]).to eq("Ingredient list removed successfully")
      expect(response).to redirect_to(ingredient_lists_path)
    end

    it "sets an alert when the ingredient list cannot be found" do
      delete :destroy, params: { id: 9999 }

      expect(flash[:alert]).to eq("Ingredient list with id 9999 not found")
      expect(response).to redirect_to(ingredient_lists_path)
    end
  end

  describe "GET #add_ingredients" do
    it "renders the show template with an empty selection state" do
      get :add_ingredients

      expect(response).to have_http_status(:ok)
      expect(controller.instance_variable_get(:@ingredient_list)).to be_nil
      expect(controller.instance_variable_get(:@selected_ingredients)).to eq([])
    end
  end

  describe "PATCH #update" do
    let(:list) { user.ingredient_lists.create!(title: "My List") }
    let(:params) do
      {
        id: list.id,
        ingredient_list: {
          title: " ",
          selected_ingredient_ids: ["123", "", "123"],
        }
      }
    end

    it "shows validation errors when update! raises ActiveRecord::RecordInvalid" do
      error_record = IngredientList.new
      error_record.errors.add(:base, "Validation failed")
      allow_any_instance_of(IngredientList).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(error_record))

      patch :update, params: params

      expect(flash[:alert]).to eq("Validation failed")
      expect(response).to redirect_to(ingredient_list_path(list))
    end

    it "falls back to a generic error when an unexpected exception occurs" do
      allow(controller).to receive(:sync_selected_ingredients).and_raise(StandardError.new("boom"))

      patch :update, params: params

      expect(flash[:alert]).to eq("We couldn't save your ingredient list. Please try again.")
      expect(response).to redirect_to(ingredient_list_path(list))
    end
  end

  describe "GET #ingredient_search" do
    it "returns a bad gateway JSON response when the search fails" do
      allow(MealDbClient).to receive(:search_ingredients).and_raise(StandardError.new("fail"))

      get :ingredient_search, params: { q: "apple" }, format: :json

      expect(response).to have_http_status(:bad_gateway)
      expect(JSON.parse(response.body)).to eq("ingredients" => [])
    end

    it "renders the show template with an empty search list on HTML failures" do
      allow(MealDbClient).to receive(:search_ingredients).and_raise(StandardError.new("fail"))

      get :ingredient_search, params: { q: "apple" }

      expect(response).to have_http_status(:bad_gateway)
      expect(controller.instance_variable_get(:@search_items)).to eq([])
    end
  end

  describe "GET #show" do
    it "redirects to the index when the list is missing" do
      get :show, params: { id: 1234 }

      expect(response).to redirect_to(ingredient_lists_path)
      expect(flash[:alert]).to eq("Ingredient list with id 1234 not found")
    end
  end

  describe "#find_ingredient_list" do
    it "falls back to a global lookup when the current user has no ingredient lists association" do
      list = IngredientList.create!(user: user, title: "Shared list")
      allow(controller).to receive(:current_user).and_return(Object.new)

      result = controller.send(:find_ingredient_list, list.id)

      expect(result).to eq(list)
    end
  end
end
