Then("I should see the recipes that can be cooked using ingredient list titled {string}") do |title|
  lst = IngredientList.find_by(title: title)
  expect(lst).not_to be_nil

  expect(page).to have_current_path("/ingredient_list_recipes/#{lst.id}")
end
