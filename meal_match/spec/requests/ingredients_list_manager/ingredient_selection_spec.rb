require "rails_helper"

RSpec.describe "Ingredient selection UI", type: :system do
  let(:user) { instance_double("User", first_name: "Test", last_name: "User", email: "test@example.com") }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "lets user click a search result to select it and shows it in the selected area" do
    allow(MealDbClient).to receive(:search_ingredients).with("tomato").and_return([
      { id: '10', name: 'Tomato', description: 'Red vegetable' }
    ])

  visit "/ingredient-list"
    click_button "Add Ingredients +"

    # type to trigger search
    fill_in "Search ingredients", with: "tomato"
    # extra keystroke to ensure input event fires if needed
    find('#ingredients-search').send_keys('s')

    expect(page).to have_text('Tomato', wait: 5)

    # click the result
    find('#ingredient-results ul li', text: 'Tomato').click

    # selected area should contain the chosen ingredient
    expect(page).to have_selector('#ingredient-selected ul li', text: 'Tomato', wait: 5)

    # clicking the selected tag should remove it
    find('#ingredient-selected ul li', text: 'Tomato').click
    expect(page).to have_no_selector('#ingredient-selected ul li', text: 'Tomato', wait: 5)
  end
end
