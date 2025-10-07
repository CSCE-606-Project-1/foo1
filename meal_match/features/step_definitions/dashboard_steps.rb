SEARCH_RECIPES_BTN_LABEL = "Search Recipe"

Given("I am on the user dashboard page") do
  visit dashboard_path
end

When("I select the ingredient list titled {string}") do |title|
  select title, from: "ingredient-list-selection-dropdown"
end

When("I click to search recipes") do
  click_button SEARCH_RECIPES_BTN_LABEL
end

Then("I should be asked to select an ingredient list first") do
  expect(page).to have_content("Please select an ingredient list !")
  expect(page).to have_current_path(dashboard_path)
end
