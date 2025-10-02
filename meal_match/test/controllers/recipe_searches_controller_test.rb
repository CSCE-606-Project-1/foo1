require "test_helper"

class RecipeSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe_search = recipe_searches(:one)
  end

  test "should get index" do
    get recipe_searches_url
    assert_response :success
  end

  test "should get new" do
    get new_recipe_search_url
    assert_response :success
  end

  test "should create recipe_search" do
    assert_difference("RecipeSearch.count") do
      post recipe_searches_url, params: { recipe_search: { ingredients: @recipe_search.ingredients } }
    end

    assert_redirected_to recipe_search_url(RecipeSearch.last)
  end

  test "should show recipe_search" do
    get recipe_search_url(@recipe_search)
    assert_response :success
  end

  test "should get edit" do
    get edit_recipe_search_url(@recipe_search)
    assert_response :success
  end

  test "should update recipe_search" do
    patch recipe_search_url(@recipe_search), params: { recipe_search: { ingredients: @recipe_search.ingredients } }
    assert_redirected_to recipe_search_url(@recipe_search)
  end

  test "should destroy recipe_search" do
    assert_difference("RecipeSearch.count", -1) do
      delete recipe_search_url(@recipe_search)
    end

    assert_redirected_to recipe_searches_url
  end
end
