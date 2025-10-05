Given("I am logged in") do
  @user = User.create!(first_name: "Test", last_name: "User", email: "test@example.com")
  visit login_path
  # Simulate session manually
  page.set_rack_session(user_id: @user.id)
end

When("I create a new ingredient list") do
  visit ingredient_lists_path
  click_button "Create new list"
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

When("I visit the dashboard") do
  visit dashboard_path
end

When("I select that ingredient list") do
  select @user.ingredient_lists.first.title, from: "ingredient_list_id"
end

When("I search for recipes") do
  click_button "Search Recipe"
end

Then('I should see {string} or {string}') do |text1, text2|
  expect(page).to have_content(text1) || have_content(text2)
end
