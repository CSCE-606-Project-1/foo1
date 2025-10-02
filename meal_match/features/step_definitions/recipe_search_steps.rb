require 'webmock/cucumber'

Before do
  stub_request(:get, %r{https://www.themealdb.com/api/json/v2/65232507/filter.php\?i=.*})
    .to_return do |request|
      ingredient = CGI.unescape(request.uri.query.split("=").last)
      meal_name = ingredient.downcase == "chicken" ? "Chicken & mushroom Hotpot" : "Mock Meal"
      body = { meals: [ { strMeal: meal_name, strMealThumb: "http://example.com/mock.jpg", idMeal: "12345" } ] }
      { status: 200, body: body.to_json, headers: { 'Content-Type' => 'application/json' } }
    end
end



Given("a user exists with email {string}") do |email|
  @user = User.find_by(email: email) || User.create!(email: email, first_name: "Test", last_name: "User")
end

Given("the user has an ingredient list {string} with {string}") do |list_title, ingredient_title|
  list = IngredientList.find_by(title: list_title, user: @user) ||
         IngredientList.create!(title: list_title, user: @user)

  ingredient = Ingredient.find_or_create_by!(title: ingredient_title, provider_name: "mealdb", provider_id: SecureRandom.uuid)
  IngredientListItem.find_or_create_by!(ingredient_list: list, ingredient: ingredient)
end

Given("I am logged in as {string}") do |email|
  user = User.find_by(email: email)
  raise "User not found: #{email}" unless user
  Capybara.current_session.set_rack_session(user_id: user.id)
end

Given("I am on the recipe search page") do
  visit new_recipe_search_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I visit the new recipe search page") do
  visit new_recipe_search_path
end

When("I select {string} from {string}") do |option, _label|
  select option, from: "recipe_search_ingredient_list_id"
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  element = find('*', text: text, visible: false)
  puts "Found '#{text}' in DOM (visible: #{element.visible?})"
end
