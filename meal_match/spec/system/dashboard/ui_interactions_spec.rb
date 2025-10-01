require "rails_helper"

RSpec.describe "Dashboard", type: :system do
  let(:user) do
    User.create!(email: "solidsnake@gmail.com",
                 first_name: "Solid",
                 last_name: "Snake")
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "allows the user to manage ingredient lists" do
    visit "/dashboard"

    # Guard so we fail loudly if something redirects us
    # (Ignore the query parameters during the check, we only care that
    # that the /dashboard URI is matched
    expect(page).to have_current_path("/dashboard", ignore_query: true)

    # Ensure that there exists some UI component to manage ingredient lists
    expect(page).to have_button(id: "manage-ingredient-lists-btn")
    click_button "manage-ingredient-lists-btn"

    # Ensure that clicking on that takes us to the correct URI (index page
    # for ingredient list viewing
    expect(page).to have_current_path("/ingredient_lists", ignore_query: true)
  end

  it "allows the user to select a created ingredient list for recipe search" do
    IngredientList.create!(user: user, title: "List 1")
    IngredientList.create!(user: user, title: "List 2")

    visit "/dashboard"

    # Guard so we fail loudly if something redirects us
    # (Ignore the query parameters during the check, we only care that
    # that the /dashboard URI is matched
    expect(page).to have_current_path("/dashboard", ignore_query: true)

    # Ensure there exists some UI component to select ingredient list
    expect(page).to have_select(id: "ingredient-list-selection-dropdown")

    # Ensure there is a UI component to search for recipes.
    expect(page).to have_button(id: "recipe-search-submit")

    # Ensure that selecting an ingredient list and clicking on submit takes
    # user to the correct URI for recipe search.
    lst = user.ingredient_lists.first
    select "#{lst.title}", from: "ingredient-list-selection-dropdown"

    click_button "recipe-search-submit"

    # We only care about URI, the URI should contain the correct
    # ingredient list id, ignore the query params
    expect(page).to have_current_path(
        "/recipes/ingredient_lists/#{lst.id}",
        ignore_query: true)
  end
end
