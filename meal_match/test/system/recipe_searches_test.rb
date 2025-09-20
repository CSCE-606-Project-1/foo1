require "application_system_test_case"

class RecipeSearchesTest < ApplicationSystemTestCase
  setup do
    @recipe_search = recipe_searches(:one)
  end

  test "visiting the index" do
    visit recipe_searches_url
    assert_selector "h1", text: "Recipe searches"
  end

  test "should create recipe search" do
    visit recipe_searches_url
    click_on "New recipe search"

    fill_in "Ingredients", with: @recipe_search.ingredients
    click_on "Create Recipe search"

    assert_text "Recipe search was successfully created"
    click_on "Back"
  end

  test "should update Recipe search" do
    visit recipe_search_url(@recipe_search)
    click_on "Edit this recipe search", match: :first

    fill_in "Ingredients", with: @recipe_search.ingredients
    click_on "Update Recipe search"

    assert_text "Recipe search was successfully updated"
    click_on "Back"
  end

  test "should destroy Recipe search" do
    visit recipe_search_url(@recipe_search)
    click_on "Destroy this recipe search", match: :first

    assert_text "Recipe search was successfully destroyed"
  end
end
