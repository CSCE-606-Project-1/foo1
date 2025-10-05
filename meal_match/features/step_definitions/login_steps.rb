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
  click_button "Sign in with Google"
end

Then("I should see the user dashboard") do
  expect(page).to have_current_path(dashboard_path)
  expect(page).to have_content("Dashboard")
end
