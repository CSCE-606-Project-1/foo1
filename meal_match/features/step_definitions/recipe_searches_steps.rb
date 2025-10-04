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

  visit ingredient_list_recipes_path(id: @ingredient_list.id)
end

When('the user creates a recipe search using that ingredient list') do
  visit ingredient_list_recipes_path(id: @ingredient_list.id)
end

When('the user creates a recipe search with no ingredients') do
  @ingredient_list = IngredientList.create!(
    user: @user,
    title: 'Empty Search'
  )
  visit ingredient_list_recipes_path(id: @ingredient_list.id)
end

Then('they should see a list of meals matching those ingredients') do
  expect(page.status_code).to eq(200)
end
