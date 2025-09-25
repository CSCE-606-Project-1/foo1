# spec/system/dashboard/add_ing_modal_spec.rb
# (folder "system" optional; you already have `type: :system`)
require "rails_helper"

RSpec.describe "Dashboard Add Ingredients modal", type: :system do
  let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }
  # Reusable selectors for modal hidden/visible states used by expectations
  let(:modal_hidden_selector) { '#ingredients-modal[hidden]' }
  let(:modal_visible_selector) { '#ingredients-modal:not([hidden])' }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end

  it "is hidden by default, opens on click, and closes on Close or ESC" do
  visit "/add-ingredients"

  # Guard so we fail loudly if something redirects us
  expect(page).to have_current_path("/add-ingredients", ignore_query: true)
    expect(page).to have_button("Add Ingredients +")

    # The modal should be hidden initially
    expect(page).to have_selector(modal_hidden_selector, visible: :all)

    click_button "Add Ingredients +"
    # Clicking the button should open the modal
    expect(page).to have_selector(modal_visible_selector, visible: :all)
    expect(page).to have_content("Add Ingredients")

    find("#ingredients-close-btn").click
    # Closing via the Close button hides the modal again
    expect(page).to have_selector(modal_hidden_selector, visible: :all)

    click_button "Add Ingredients +"
    # Re-open the modal
    expect(page).to have_selector(modal_visible_selector, visible: :all)

    find("body").send_keys(:escape)
    # Pressing Escape should also close the modal
    expect(page).to have_selector(modal_hidden_selector, visible: :all)
  end
end
