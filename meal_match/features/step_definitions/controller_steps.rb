# frozen_string_literal: true

require "capybara/rspec"
require "rspec/mocks"

Given("controller: a user exists and is logged in") do
  @user = User.create!(email: "feature@example.com", first_name: "Feat", last_name: "User")
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
end

Given("controller: an ingredient list exists titled {string}") do |title|
  @ingredient_list = @user.ingredient_lists.create!(title:)
end

Given("controller: MealDbClient raises an error during search") do
  allow(MealDbClient).to receive(:filter_by_ingredients).and_raise(StandardError, "boom")
end

Given("controller: MealDbClient raises an error during ingredient search") do
  allow(MealDbClient).to receive(:search_ingredients).and_raise(StandardError, "fail")
end

Given("controller: IngredientList update! raises ActiveRecord::RecordInvalid") do
  list = @user.ingredient_lists.last
  list.errors.add(:title, "can't be blank")
  allow_any_instance_of(IngredientList).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(list))
end

Given("controller: IngredientList update! raises a generic StandardError") do
  allow_any_instance_of(IngredientList).to receive(:update!).and_raise(StandardError, "boom")
end

When("controller: I visit {string}") do |path|
  visit path
end

When("controller: I post to {string} with {string}") do |path, params|
  page.driver.post path, Rack::Utils.parse_nested_query(params)
end

When("controller: I get {string} with {string}") do |path, params|
  page.driver.get path, Rack::Utils.parse_nested_query(params)
end

When("controller: I submit a PATCH request to update that ingredient list") do
  list = @ingredient_list || @user.ingredient_lists.last
  page.driver.submit :patch, "/ingredient_lists/#{list.id}", { ingredient_list: { title: "X" } }
end

Then("controller: I should be redirected to {string}") do |dest|
  expect(page).to have_current_path(dest, ignore_query: true)
end

Then("controller: I should see {string}") do |text|
  decoded_body = CGI.unescapeHTML(page.body)
  expect(decoded_body).to include(text)
end

Then("controller: the JSON response should contain empty ingredients") do
  json = JSON.parse(page.body)
  expect(json["ingredients"]).to eq([])
end

Then("controller: the response status should be {int}") do |status|
  expect(page.status_code).to eq(status)
end

Then("controller: the HTML page should contain {string}") do |text|
  expect(page.body).to include(text)
end

Then("controller: I should be redirected to the ingredient list show page") do
  list = @ingredient_list || @user.ingredient_lists.last
  expect(page).to have_current_path(ingredient_list_path(list), ignore_query: true)
end

When("controller: I visit last ingredient list search path") do
  list = @ingredient_list || @user.ingredient_lists.last
  visit "/recipes/ingredient_lists/#{list.id}"
end
