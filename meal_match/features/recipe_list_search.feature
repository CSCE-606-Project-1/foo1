Feature: Recipe Search with Ingredient Lists
  As a user
  I want to select a saved ingredient list or input ingredients manually
  So that I can search for recipes easily

  Background:
    Given a user exists with email "test@example.com"
    And the user has an ingredient list "Protein List" with "Chicken Breast"

  Scenario: Search using an ingredient list
    Given I am logged in as "test@example.com"
    When I visit the new recipe search page
    And I select "Protein List" from "Or choose an Ingredient List"
    And I press "Search"
    Then I should see "Mock Meal"

  Scenario: Search using manual ingredients
    Given I am logged in as "test@example.com"
    When I visit the new recipe search page
    And I fill in "Enter ingredients (comma separated)" with "Chole, Pav"
    And I press "Search"
    Then I should see "Mock Meal"
