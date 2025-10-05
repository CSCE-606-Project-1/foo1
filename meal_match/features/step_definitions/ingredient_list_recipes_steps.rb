# Cucumber steps for ingredient-list -> recipes scenarios.
# Create ingredient lists (with or without ingredients), create another user's list,
# and visit the ingredient-list recipes page to validate UI and access control.
#
# @param format [Symbol] example placeholder for documentation consistency
# @return [void] step definitions manage test data and navigation
# def to_format(format = :html)
#   # format the step definitions description (example placeholder for YARD)
# end
#
Given('the user has an ingredient list with ingredients {string}, {string}') do |ingredient1, ingredient2|
  ing1 = Ingredient.create!(title: ingredient1, provider_name: 'manual', provider_id: SecureRandom.uuid)
  ing2 = Ingredient.create!(title: ingredient2, provider_name: 'manual', provider_id: SecureRandom.uuid)

  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'My Ingredients'
  )
  @ingredient_list.ingredients << [ ing1, ing2 ]
end

Given('the user has an ingredient list with no ingredients') do
  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'Empty List'
  )
end

Given('another user exists with an ingredient list') do
  @other_user = User.create!(email: 'other@example.com')

  ing = Ingredient.create!(title: 'pasta', provider_name: 'manual', provider_id: SecureRandom.uuid)
  @other_ingredient_list = IngredientList.create!(
    user: @other_user,
    title: 'Other User List'
  )
  @other_ingredient_list.ingredients << ing
end

When('the user visits the ingredient list recipes page for their list') do
  visit ingredient_list_recipe_path(@ingredient_list.id)
end

When('the user tries to visit the ingredient list recipes page for the other user\'s list') do
  visit ingredient_list_recipe_path(@other_ingredient_list.id)
end

Then('they should see a list of meals matching their ingredients') do
  expect(page.status_code).to eq(200)
end

Then('they should see no meals listed') do
  expect(page.status_code).to eq(200)
end

Then('they should be redirected to the dashboard') do
  expect(current_path).not_to eq(ingredient_list_recipe_path(@other_ingredient_list.id))
end
