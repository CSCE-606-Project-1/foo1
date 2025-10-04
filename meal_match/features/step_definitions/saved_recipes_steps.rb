Given('the user has saved a recipe') do
  @recipe = @user.saved_recipes.create!(
    meal_id: '12345',
    name: 'Test Meal',
    thumbnail: 'http://example.com/image.jpg'
  )
end

When('the user saves a recipe with meal_id {string}, name {string}, and thumbnail {string}') do |meal_id, name, thumbnail|
  @user.saved_recipes.create!(
    meal_id: meal_id,
    name: name,
    thumbnail: thumbnail
  )
end

When('the user visits their saved recipes page') do
  visit '/saved_recipes'
end

Then('the recipe should appear in their saved recipes list') do
  visit '/saved_recipes'
  expect(page).to have_content('Test Meal')
end

Then('they should see their saved recipe') do
  expect(page).to have_content('Test Meal')
end

When('the user deletes the saved recipe') do
  visit '/saved_recipes'
  click_link_or_button 'Remove'
end

Then('the recipe should no longer appear in their saved recipes list') do
  visit '/saved_recipes'
  expect(page).not_to have_content('Test Meal')
end
