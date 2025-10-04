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
