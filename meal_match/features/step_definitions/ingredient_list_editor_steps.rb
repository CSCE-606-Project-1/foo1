INGREDIENT_NAME_FIELD_LABEL = "Ingredient list name"
NO_JS_RESULTS_SELECTOR = ".no-js-results"
NO_JS_SELECTED_SELECTOR = ".no-js-selected"

def ingredient_catalog_data(table)
  table.hashes.map do |row|
    {
      id:          row.fetch("id").to_s,
      name:        row.fetch("name"),
      description: row["description"].to_s
    }
  end
end

def ingredient_list_for(title)
  raise "Expected a logged in user, but was nil !" if @logged_in_user.nil?

  IngredientList.find_by!(user: @logged_in_user, title: title)
end

def ensure_ingredient_record(id:, name:)
  Ingredient.find_or_create_by!(
    provider_name: Ingredient::THEMEALDB_PROVIDER,
    provider_id: id
  ) do |ingredient|
    ingredient.title = name
  end
end

Given("the ingredient catalog contains:") do |table|
  data = ingredient_catalog_data(table)
  allow(MealDbClient).to receive(:fetch_all_ingredients).and_return(data)
  allow(MealDbClient).to receive(:search_ingredients) do |query|
    q = query.to_s.strip.downcase
    next [] if q.empty?

    data.select { |item| item[:name].downcase.include?(q) }[0, 25]
  end
end

Given("the ingredient list titled {string} already contains the following ingredients:") do |title, table|
  list = ingredient_list_for(title)
  table.hashes.each do |row|
    ingredient = ensure_ingredient_record(id: row.fetch("id").to_s, name: row.fetch("name"))
    list.ingredients << ingredient unless list.ingredients.exists?(ingredient.id)
  end
end

When("I open the ingredient list titled {string} for editing") do |title|
  list = ingredient_list_for(title)
  visit ingredient_list_path(list)
  @current_ingredient_list = list
end

When("I search for {string}") do |query|
  fill_in "no-js-search-input", with: query
  click_button "Search"
end

Then("I should see the ingredient search results:") do |table|
  within(NO_JS_RESULTS_SELECTOR) do
    expected = table.raw.flatten
    actual = all("label span").map(&:text)
    expect(actual).to match_array(expected)
  end
end

Then("I should see a message that no ingredients were found") do
  expect(page).to have_css("#ingredient-results", text: "No ingredients found", visible: :all)
end

When("I select the ingredient {string}") do |name|
  check name
end

When("I select the ingredients:") do |table|
  table.raw.flatten.each { |name| check name }
end

When("I deselect the ingredient {string}") do |name|
  uncheck name
end

When("I save the ingredient list") do
  fallback_submit = first(:xpath, "//noscript//input[@type='submit' and @value='Save']", visible: :all, wait: 0)
  if fallback_submit
    fallback_submit.click
  else
    click_button "Save"
  end
end

Then("the ingredient list titled {string} should contain only the following ingredients:") do |title, table|
  list = ingredient_list_for(title)
  list.reload
  expected = table.raw.flatten
  actual = list.ingredients.order(:title).pluck(:title)
  expect(actual).to match_array(expected)
end

Then("the ingredient list titled {string} should have no ingredients") do |title|
  list = ingredient_list_for(title)
  expect(list.reload.ingredients).to be_empty
end

When("I rename the ingredient list to {string}") do |new_name|
  fill_in INGREDIENT_NAME_FIELD_LABEL, with: new_name
end

Then("I should be on the ingredient lists manager page") do
  expect(page).to have_current_path(ingredient_lists_path, ignore_query: true)
end

Then("the ingredient list name field should contain {string}") do |expected|
  field = find_field(INGREDIENT_NAME_FIELD_LABEL)
  expect(field.value).to eq(expected)
end

Then("the ingredient list should show the selected ingredients:") do |table|
  expected = table.raw.flatten
  within(NO_JS_SELECTED_SELECTOR) do
    actual = all("label span").map(&:text)
    expect(actual).to match_array(expected)
  end
end

Then("the ingredient list should indicate that no ingredients are selected") do
  expect(page).not_to have_css(NO_JS_SELECTED_SELECTOR)
end

When("I open the add ingredients modal") do
  find("#add-ingredients-btn").click
  expect(page).to have_css("#ingredients-modal", visible: true)
end

When("I type {string} into the ingredient search") do |query|
  fill_in "ingredients-search", with: query
end

When("I pick the ingredient {string} from the results") do |name|
  expect(page).to have_css("#ingredient-results li", text: name, wait: 5)
  find("#ingredient-results li", text: name).click
end

When("I close the add ingredients modal") do
  find("#ingredients-close-btn").click
end

Then("the add ingredients modal should be hidden") do
  expect(page).to have_no_css("#ingredients-modal", visible: true)
end

Then("the ingredient search field should be empty") do
  field = find("#ingredients-search", visible: :all)
  expect(field.value).to eq("")
end
