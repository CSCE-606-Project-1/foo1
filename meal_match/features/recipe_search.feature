Feature: Recipe search
  As a user
  I want to search for recipes by ingredient
  So that I can find meals to cook

  Scenario: Search with one ingredient
    Given a user exists with email "test@example.com"
    And I am logged in as "test@example.com"
    When I visit the new recipe search page
    And I fill in "ingredient" with "chicken"
    And I press "Search"
    Then I should see "Chicken & mushroom Hotpot"
