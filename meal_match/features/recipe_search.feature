# Feature: Recipes search controller
# As a logged-in user
# I want to handle missing and valid ingredient lists
# So that all recipe search controller branches are covered

Feature: Recipes search controller

  Background:
    Given controller: a user exists and is logged in

  Scenario: Visiting recipe search with no ingredient_list_id redirects to dashboard
    When controller: I visit "/recipes/ingredient_lists/intermediate"
    Then controller: I should be redirected to "/dashboard"
    And controller: I should see "Please select an ingredient list"

  Scenario: Visiting recipe search with an invalid ingredient_list_id redirects to dashboard
    When controller: I visit "/recipes/ingredient_lists/999999"
    Then controller: I should be redirected to "/dashboard"
    And controller: I should see "does not exist"

  Scenario: Visiting recipe search with an ingredient list that raises error
    Given controller: an ingredient list exists titled "SpecList"
    And controller: MealDbClient raises an error during search
    When controller: I visit last ingredient list search path
    Then controller: I should see "Error fetching recipes"

  Scenario: Visiting recipe search intermediate with no ID redirects to dashboard
    When controller: I visit "/recipes/ingredient_lists/intermediate"
    Then controller: I should be redirected to "/dashboard"
    And controller: I should see "Please select an ingredient list"
