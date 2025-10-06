CREATE_INGREDIENT_LIST_BTN_LABEL = "Create new list"
INGREDIENT_LISTS_TABLE_BODY_ID = "ingredient-lists-table-body"
DELETE_INGREDIENT_LIST_BTN_LABEL = "Delete"
TABLE_BODY_CSS = "[data-testid='#{INGREDIENT_LISTS_TABLE_BODY_ID}']"
INGREDIENT_LISTS_TABLE_ID = "ingredient-lists-table"

def ingredient_lists_table_last_row
  within(TABLE_BODY_CSS) do
    all("tr").last
  end
end

def ingredient_lists_table_row_with_title(title)
  within(TABLE_BODY_CSS) do
    find("tr", text: title)
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

Given("I have already created an ingredient list titled {string}") do |title|
  raise "Expected a logged in user, but was nil !" if @logged_in_user.nil?
  IngredientList.create!(user: @logged_in_user, title: title)
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

When("I click to delete the ingredient list titled {string}") do |title|
  row = ingredient_lists_table_row_with_title(title)
  row.click_button(DELETE_INGREDIENT_LIST_BTN_LABEL)
end

Then("I should no longer see the ingredient list titled {string} in the ingredient lists table") do |title|
  # No table body present if there are 0 lists, hence the check is
  # necessary before trying to search within table. (When there is no
  # table, then definitely there is no ingredient list in it, so if
  # has_css? is false then also we are happy.
  if has_css?(TABLE_BODY_CSS)
    within(TABLE_BODY_CSS) do
      expect(page).not_to have_content(title)
    end
  end
end

When("I click to delete all ingredient lists") do
  # No table body present if there are 0 lists, hence the check is
  # necessary before trying to delete each ingredient list.
  while has_css?(TABLE_BODY_CSS)
    within(TABLE_BODY_CSS) do
      # We can't iterate over all rows here and press delete, since
      # one delete press reloads the page causing the html corresponding to
      # the other rows we have to be in a stale state, so do it one by one.
      first("tr").click_button(DELETE_INGREDIENT_LIST_BTN_LABEL)
    end
  end
end

Then('I should not see a table of ingredient lists') do
  save_and_open_page
  expect(page).not_to have_css("[data-testid='#{INGREDIENT_LISTS_TABLE_ID}']")
end
