Given("a user exists with email {string}") do |email|
  User.find_or_create_by!(email: email) do |user|
    user.first_name = "Test"
    user.last_name = "User"
  end
end

Given("I am logged in as {string}") do |email|
  user = User.find_by!(email: email)
  page.set_rack_session(user_id: user.id)
end

When("I visit the ingredient list page") do
  visit "/ingredient-list"
end

Then("I should see the add ingredients button") do
  expect(page).to have_button("Add Ingredients +")
end
