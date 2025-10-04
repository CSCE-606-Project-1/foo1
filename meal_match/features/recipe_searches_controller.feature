Feature: Recipe Searches

  Background:
    Given a user exists and is logged in

  Scenario: User creates a recipe search with ingredients
    When the user creates a recipe search with ingredients "beef, tomato"
    Then they should see a list of meals matching those ingredients

  Scenario: User creates a recipe search with an ingredient list
    Given the user has an ingredient list with ingredients "egg, cheese"
    When the user creates a recipe search using that ingredient list
    Then they should see a list of meals matching those ingredients

  Scenario: User creates a recipe search with no ingredients
    When the user creates a recipe search with no ingredients
    Then they should see no meals listed
