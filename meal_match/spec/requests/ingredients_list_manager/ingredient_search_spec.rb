require "rails_helper"

RSpec.describe "Ingredient search UI", type: :system do
  let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "shows matching ingredients as the user types" do
    # Stub the MealDbClient so we don't hit the network in CI
    allow(MealDbClient).to receive(:search_ingredients).with("chicken").and_return([
      { id: '1', name: 'Chicken', description: 'Poultry' },
      { id: '2', name: 'Chicken Stock', description: 'Broth' }
    ])

  visit "/ingredient-list"

    # Open the modal
    click_button "Add Ingredients +"

    # Find the search input and type
    input = find("#ingredients-search")
    input.fill_in with: 'chicken'

    # Wait for results to appear
    expect(page).to have_selector('#ingredient-results ul li', wait: 5)
    expect(page).to have_content('Chicken')
    expect(page).to have_content('Chicken Stock')
  end
end
