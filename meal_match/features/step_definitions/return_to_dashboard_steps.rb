RETURN_TO_DASHBOARD_BTN_LABEL = "Back to Dashboard"
When("I click to return to dashboard") do
  click_button RETURN_TO_DASHBOARD_BTN_LABEL
end

Then("I should not be asked to return to dashboard") do
  expect(page).not_to have_button(RETURN_TO_DASHBOARD_BTN_LABEL)
end
