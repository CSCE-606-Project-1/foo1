Feature: Recipe search
  As a user
  I want to search for recipes by ingredient
  So that I can find meals to cook

  Scenario: Search with one ingredient
    Given I am on the recipe search page
    When I fill in "ingredient" with "chicken"
    And I press "Search"
    Then I should see "Chicken & mushroom Hotpot"
