require "rails_helper"

RSpec.describe SavedRecipe, type: :model do
  let(:user) { User.create!(email: "test@example.com") }

  it "is valid with required attributes" do
    recipe = user.saved_recipes.build(meal_id: "123", name: "Pasta")
    expect(recipe).to be_valid
  end

  it "is invalid without a meal_id" do
    recipe = user.saved_recipes.build(meal_id: nil, name: "Pasta")
    expect(recipe).not_to be_valid
    expect(recipe.errors[:meal_id]).to include("can't be blank")
  end

  it "enforces uniqueness of meal_id scoped to user" do
    user.saved_recipes.create!(meal_id: "123", name: "Pasta")
    dup = user.saved_recipes.build(meal_id: "123", name: "Duplicate Pasta")
    expect(dup).not_to be_valid
    expect(dup.errors[:meal_id]).to include("has already been taken")
  end

  it "allows same meal_id for different users" do
    user2 = User.create!(email: "other@example.com")
    user.saved_recipes.create!(meal_id: "123", name: "Pasta")
    recipe2 = user2.saved_recipes.build(meal_id: "123", name: "Pasta")
    expect(recipe2).to be_valid
  end
end
