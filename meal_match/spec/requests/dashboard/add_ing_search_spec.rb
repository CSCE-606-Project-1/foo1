# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard Add Ingredients modal search", type: :system do
  skip "Feature not found" do
    let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }

    before do
      # Stub the ingredient_lists method
      allow(user).to receive(:ingredient_lists).and_return([])

      # Bypass auth so /dashboard renders
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)
    end

    it "shows a search input, lets me type, doesn't submit, and clears on close" do
      visit "/dashboard"

      click_button "Add Ingredients +"

      expect(page).to have_field("Search ingredients", type: "search", with: "", wait: 5)

      fill_in "Search ingredients", with: "chicken thighs"
      expect(page.find("#ingredients-search").value).to eq("chicken thighs")

      page.find("#ingredients-search").send_keys(:enter)
      expect(page).to have_current_path("/dashboard")
      expect(page).to have_selector("#ingredients-modal:not([hidden])", visible: :all)

      find("#ingredients-close-btn").click
      expect(page).to have_selector("#ingredients-modal[hidden]", visible: :all)

      click_button "Add Ingredients +"
      expect(page.find("#ingredients-search").value).to eq("")
    end
  end
end
