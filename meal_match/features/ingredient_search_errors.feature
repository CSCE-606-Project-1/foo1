# Feature: Ingredient search backend failure handling
# As a logged-in user
# I want the ingredient search endpoint to handle backend errors properly

Feature: Ingredient search backend failure handling

  Background:
    Given controller: a user exists and is logged in

  Scenario: JSON request returns 502 and empty array
    Given controller: MealDbClient raises an error during ingredient search
    When controller: I get "/ingredient_search.json" with "q=x"
    Then controller: the JSON response should contain empty ingredients
    And controller: the response status should be 502

  Scenario: HTML request renders show with 502 or fallback
    Given controller: MealDbClient raises an error during ingredient search
    When controller: I get "/ingredient_search" with "q=y"
    Then controller: the HTML page should contain "Manage Ingredient List"
