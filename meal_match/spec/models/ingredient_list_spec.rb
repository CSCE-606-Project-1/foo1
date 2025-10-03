require 'rails_helper'

RSpec.describe IngredientList, type: :model do
  let(:user) do
    User.create!(email: "test@gmail.com",
                 first_name: "Solid",
                 last_name: "Snake")
  end

  let(:ingredient_1) do
    Ingredient.create!(provider_name: "mealdb",
                       provider_id: "1",
                       title: "Eggs")
  end

  let(:ingredient_2) do
    Ingredient.create!(provider_name: "mealdb",
                       provider_id: "2",
                       title: "Chole")
  end

  let(:ingredient_3) do
    Ingredient.create!(provider_name: "mealdb",
                       provider_id: "3",
                       title: "Pav")
  end

  let(:ingredient_4) do
    Ingredient.create!(provider_name: "mealdb",
                       provider_id: "4",
                       title: "Misal")
  end

  describe "validations" do
    it "should not complain in case of happy path" do
      l = IngredientList.new(user: user, title: "abc")
      expect(l).to be_valid
    end

    it "should fail if not created against a user" do
      l = IngredientList.new(title: "abc")
      expect(l).not_to be_valid
    end

    it "should have a title" do
      l = IngredientList.new(user: user)
      expect(l).not_to be_valid
    end
  end

  it "should belong to one user (i.e proprely associate with the user)" do
    l1 = IngredientList.create!(user: user, title: "abc")
    expect(l1).to be_valid

    l2 = IngredientList.create!(user: user, title: "pqr")
    expect(l2).to be_valid

    expect(user.ingredient_lists).to include(l1, l2)
  end

  it "should be able to have many ingredients" do
    l = IngredientList.create!(user: user, title: "abc")
    expect(l).to be_valid

    IngredientListItem.create!(ingredient_list: l, ingredient: ingredient_1)
    IngredientListItem.create!(ingredient_list: l, ingredient: ingredient_2)

    expect(l.ingredients).to include(ingredient_1, ingredient_2)
    expect(l.ingredients.size).to eq(2)
  end

  it "should not allow duplicating ingredients within a list" do
    l = IngredientList.create!(user: user, title: "abc")
    expect(l).to be_valid

    IngredientListItem.create!(ingredient_list: l, ingredient: ingredient_1)

    li_2 = IngredientListItem.new(ingredient_list: l, ingredient: ingredient_1)
    expect(li_2).not_to be_valid
  end

  it "should allow duplicating ingredients within two different lists" do
    l1 = IngredientList.create!(user: user, title: "abc")
    expect(l1).to be_valid

    l2 = IngredientList.create!(user: user, title: "pqr")
    expect(l2).to be_valid

    IngredientListItem.create!(ingredient_list: l1, ingredient: ingredient_1)
    IngredientListItem.create!(ingredient_list: l1, ingredient: ingredient_2)

    IngredientListItem.create!(ingredient_list: l2, ingredient: ingredient_2)
    IngredientListItem.create!(ingredient_list: l2, ingredient: ingredient_3)

    expect(l1.ingredients).to include(ingredient_1, ingredient_2)
    expect(l1.ingredients.size).to eq(2)

    expect(l2.ingredients).to include(ingredient_2, ingredient_3)
    expect(l2.ingredients.size).to eq(2)
  end
end
