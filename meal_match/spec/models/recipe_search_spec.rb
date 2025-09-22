require 'rails_helper'

RSpec.describe RecipeSearch, type: :model do
  it { should belong_to(:ingredient_list).optional }

  it "can store raw ingredients" do
    search = RecipeSearch.new(ingredients: "Chicken, Chole")
    expect(search.ingredients).to eq("Chicken, Chole")
  end

  it "can store ingredient_list" do
    user = User.create!(email: "test@example.com")
    list = IngredientList.create!(user: user, title: "Protein List")
    search = RecipeSearch.new(ingredient_list: list)
    expect(search.ingredient_list).to eq(list)
  end
end
