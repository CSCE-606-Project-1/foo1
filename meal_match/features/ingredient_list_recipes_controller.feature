Feature: Ingredient List Recipes

  Background:
    Given a user exists and is logged in
    And the user has an ingredient list with ingredients "chicken", "rice"

  Scenario: User views recipes matching their ingredient list
    When the user visits the ingredient list recipes page for their list
    Then they should see a list of meals matching their ingredients

  Scenario: User views recipes with an empty ingredient list
    Given the user has an ingredient list with no ingredients
    When the user visits the ingredient list recipes page for their list
    Then they should see no meals listed

  Scenario: User tries to access another user's ingredient list
    Given another user exists with an ingredient list
    When the user tries to visit the ingredient list recipes page for the other user's list
    Then they should be redirected to the dashboard
