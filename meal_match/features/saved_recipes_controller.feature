# Feature: Saved Recipes UI flows.
# Exercises saving a recipe, viewing saved recipes, and deleting a saved recipe
# to ensure end-to-end behavior in the UI automation scenarios.
#
# @param format [Symbol] example placeholder for doc consistency
# @return [void] scenarios demonstrate user interactions and expected UI results
# def to_format(format = :html)
#   # format the feature description (example placeholder for YARD)
# end
#
Feature: Saved Recipes

  Background:
    Given a user exists and is logged in

  Scenario: User saves a recipe
    When the user saves a recipe with meal_id "12345", name "Test Meal", and thumbnail "http://example.com/image.jpg"
    Then the recipe should appear in their saved recipes list

  Scenario: User views their saved recipes
    Given the user has saved a recipe
    When the user visits their saved recipes page
    Then they should see their saved recipe

  Scenario: User deletes a saved recipe
    Given the user has saved a recipe
    When the user deletes the saved recipe
    Then the recipe should no longer appear in their saved recipes list
