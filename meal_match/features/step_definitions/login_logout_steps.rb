LOGIN_BTN_LABEL = "Sign in with Google"
LOGOUT_BTN_LABEL = "Log out"

Given("I am a non logged in user") do
  # logout request is DELETE /logout not GET /logout
  # so the normal visit logout_path won't work since
  # it tries to send a GET request.
  page.driver.submit :delete, '/logout', {}
  begin
    page.driver.browser.clear_cookies
  rescue StandardError => e
    puts "Could not clear cookies: #{e.message}"
  end
end

Given("I am on the home page") do
  visit root_path
end

When("I click to sign in with google") do
  click_button LOGIN_BTN_LABEL

  @logged_in_user = User.find_by(email: TEST_USER_EMAIL)
  if @logged_in_user.nil?
    raise "Expected logged in user #{TEST_USER_EMAIL} to exist !"
  end
end

Then("I should see the user dashboard") do
  expect(page).to have_current_path(dashboard_path)
  expect(page).to have_content("Dashboard")
end

Given("I am a logged in user") do
  step "I am a non logged in user"
  step "I am on the home page"
  step "I click to sign in with google"
  step "I should see the user dashboard"
end

When("I click to log out") do
  click_button LOGOUT_BTN_LABEL
end

Then("I should see the login page") do
  expect(page).to have_current_path(login_path)
  expect(page).to have_content("Login")
end

Then("I should not be asked to sign in with google") do
  expect(page).not_to have_button(LOGIN_BTN_LABEL)
end

Then("I should not be asked to logout") do
  expect(page).not_to have_button(LOGOUT_BTN_LABEL)
end
