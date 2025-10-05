require "rails_helper"

RSpec.describe "IngredientLists edge cases", type: :request do
  let(:user) { User.create!(email: "u@example.com", first_name: "U", last_name: "S") }
  let!(:list) { IngredientList.create!(user: user, title: "Test List") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "redirects when accessing another user's list" do
    other = User.create!(email: "o@example.com")
    other_list = IngredientList.create!(user: other, title: "Other")
    get ingredient_list_path(other_list)
    expect(response).to redirect_to(ingredient_lists_path)
  end

  it "redirects gracefully when destroying non-existent list" do
    delete "/ingredient_lists/999999"
    expect(response).to redirect_to(ingredient_lists_path)
  end

  it "assigns Untitled list when title is blank" do
    post ingredient_lists_path, params: { ingredient_list: { title: "" } }
    expect(IngredientList.last.title).to eq("Untitled list")
  end

  it "redirects when updating another user's list" do
    other = User.create!(email: "other@example.com")
    other_list = IngredientList.create!(title: "Other List", user: other)
    patch ingredient_list_path(other_list), params: { ingredient_list: { title: "Hack" } }
    expect(response).to redirect_to(ingredient_lists_path)
  end

  it "redirects when deleting a non-existent list" do
    delete ingredient_list_path(id: 999_999)
    expect(response).to redirect_to(ingredient_lists_path)
  end
end
