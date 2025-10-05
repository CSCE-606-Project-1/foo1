Feature: Manage ingredients and recipes
  As a logged-in user
  I want to manage my ingredient lists and save recipes
  So that I can plan meals easily

  Scenario: Create list and visit recipe search
    Given I am logged in
    When I create a new ingredient list
    Then I should see "New ingredient list created successfully"
    When I visit the dashboard
    And I select that ingredient list
    And I search for recipes
    Then I should see "No recipes found" or "Recipes for"
