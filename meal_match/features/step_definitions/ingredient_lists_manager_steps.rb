CREATE_INGREDIENT_LIST_BTN_LABEL = "Create new list"

def ingredient_lists_table_last_row
  within("[data-testid='ingredient-lists-table-body']") do
    all("tr").last
  end
end

Given("I am on the ingredient lists manager page") do
  visit ingredient_lists_path
end

Given("I have already created a few ingredient lists") do
  raise "Expected a logged in user, but was nil !" if @logged_in_user.nil?
  IngredientList.create!(user: @logged_in_user, title: "Monday Meal Plan")
  IngredientList.create!(user: @logged_in_user, title: "Tuesday Meal Plan")
end

When("I click to create a new ingredient list") do
  click_button CREATE_INGREDIENT_LIST_BTN_LABEL
end

Then("I should see the newly created ingredient list below the previously created lists") do
  raise "Expected a logged in user, but was nil !" if @logged_in_user.nil?

  # Most recently created list by the user
  list_id = @logged_in_user.ingredient_lists.order(created_at: :desc).first.id
  raise "No ingredient list found for user" if list_id.nil?

  last_row = ingredient_lists_table_last_row
  expect(last_row["data-testid"]).to eq("ingredient-list-#{list_id}")
end

Then("I should see the newly created list with the default title {string}") do |default_title|
  raise "Expected a logged in user, but was nil !" if @logged_in_user.nil?

  list_id = @logged_in_user.ingredient_lists.order(created_at: :desc).first.id
  raise "No ingredient list found for user" if list_id.nil?

  last_row = ingredient_lists_table_last_row
  expect(last_row["data-testid"]).to eq("ingredient-list-#{list_id}")

  first_cell = last_row.all("td").first
  expect(first_cell).to have_content(default_title)
end
