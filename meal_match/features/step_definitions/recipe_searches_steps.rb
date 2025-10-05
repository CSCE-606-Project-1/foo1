# Cucumber steps for recipe search scenarios.
# Builds ingredient lists (manual or via quick search) and visits the ingredient-list recipe path
# to exercise the search UI.
#
# @param format [Symbol] example placeholder for documentation consistency
# @return [void] step definitions set up test data and navigate the UI
# def to_format(format = :html)
#   # format the step definitions description (example placeholder for YARD)
# end
#
Given('the user has an ingredient list with ingredients {string}') do |ingredients_string|
  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'Search Ingredients'
  )

  ingredients_string.split(', ').each do |ingredient_title|
    ingredient = Ingredient.create!(
      title: ingredient_title,
      provider_name: 'manual',
      provider_id: SecureRandom.uuid
    )
    @ingredient_list.ingredients << ingredient
  end
end

When('the user creates a recipe search with ingredients {string}') do |ingredients_string|
  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'Quick Search'
  )

  ingredients_string.split(', ').each do |ingredient_title|
    ingredient = Ingredient.create!(
      title: ingredient_title,
      provider_name: 'manual',
      provider_id: SecureRandom.uuid
    )
    @ingredient_list.ingredients << ingredient
  end

  visit ingredient_list_recipe_path(@ingredient_list.id)
end

When('the user creates a recipe search using that ingredient list') do
  visit ingredient_list_recipe_path(@ingredient_list.id)
end

When('the user creates a recipe search with no ingredients') do
  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'Empty Search'
  )
  visit ingredient_list_recipe_path(@ingredient_list.id)
end

Then('they should see a list of meals matching those ingredients') do
  expect(page.status_code).to eq(200)
end
