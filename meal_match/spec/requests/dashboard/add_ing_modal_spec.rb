require "rails_helper"

RSpec.describe "Dashboard Add Ingredients modal", type: :system do
  skip "Feature not found" do
    let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }
    let(:modal_hidden_selector) { '#ingredients-modal[hidden]' }
    let(:modal_visible_selector) { '#ingredients-modal:not([hidden])' }

    before do
      # Stub the ingredient_lists method
      allow(user).to receive(:ingredient_lists).and_return([])

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)
    end

    it "is hidden by default, opens on click, and closes on Close or ESC" do
      visit "/dashboard"

      expect(page).to have_current_path("/dashboard", ignore_query: true)
      expect(page).to have_button("Add Ingredients +")

      expect(page).to have_selector(modal_hidden_selector, visible: :all)

      click_button "Add Ingredients +"
      expect(page).to have_selector(modal_visible_selector, visible: :all)
      expect(page).to have_content("Add Ingredients")

      find("#ingredients-close-btn").click
      expect(page).to have_selector(modal_hidden_selector, visible: :all)

      click_button "Add Ingredients +"
      expect(page).to have_selector(modal_visible_selector, visible: :all)

      find("body").send_keys(:escape)
      expect(page).to have_selector(modal_hidden_selector, visible: :all)
    end
  end
end
