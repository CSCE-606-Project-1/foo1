require 'rails_helper'

# Most of the actual useful tests are present in
# IngredientList model tests, these are simple tests
# to test that association is properly set
RSpec.describe IngredientListItem, type: :model do
  let(:user) do
    User.new(email: "test@gmail.com",
             first_name: "Solid",
             last_name: "Snake")
  end

  let(:lst) do
    IngredientList.new(user: user, title: "abc")
  end

  let(:ingredient) do
    Ingredient.new(provider_name: "mealdb",
                   provider_id: "1234",
                   title: "Misal",
                   description: "Tasty Indian dish made using sprout and spices")
  end

  it "should associate properly with ingredient and ingredient list" do
    li = IngredientListItem.new(ingredient_list: lst, ingredient: ingredient)
    expect(li).to be_valid
    expect(li.ingredient).to eq(ingredient)
    expect(li.ingredient_list).to eq(lst)
  end
end
