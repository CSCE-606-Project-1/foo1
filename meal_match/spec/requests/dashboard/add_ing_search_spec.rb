# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard Add Ingredients modal search", type: :system do
  let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }

  before do
    # Bypass auth so /dashboard renders
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end

  it "shows a search input, lets me type, doesn't submit, and clears on close" do
  visit "/add-ingredients"

  # Open modal
  click_button "Add Ingredients +"

    # The search field is present and focused
    expect(page).to have_field("Search ingredients", type: "search", with: "", wait: 5)

    # Type in it
    fill_in "Search ingredients", with: "chicken thighs"
    expect(page.find("#ingredients-search").value).to eq("chicken thighs")

    # Stub the backend search so tests don't call external API. Allow any
    # argument because the test triggers an extra keystroke to fire input
    # events and we don't care about the exact query string here.
    allow(MealDbClient).to receive(:search_ingredients).and_return([
      { id: "1", name: "Chicken Thighs", description: "Dark meat from chicken." }
    ])

    # Typing should trigger the JS controller which fetches results — wait for the item
    page.find("#ingredients-search").send_keys('s') # trigger input event
    expect(page).to have_text("Chicken Thighs", wait: 5)

    # Hitting Enter shouldn't navigate or close the modal
  page.find("#ingredients-search").send_keys(:enter)
  expect(page).to have_current_path("/add-ingredients") # still on add-ingredients
    expect(page).to have_selector("#ingredients-modal:not([hidden])", visible: :all)

    # Close -> input clears
    find("#ingredients-close-btn").click
    expect(page).to have_selector("#ingredients-modal[hidden]", visible: :all)

    # Re-open -> field should be empty again
    click_button "Add Ingredients +"
    expect(page.find("#ingredients-search").value).to eq("")
  end
end
