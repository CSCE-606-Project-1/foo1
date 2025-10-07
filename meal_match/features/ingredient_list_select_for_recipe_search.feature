Feature: Select Ingredient List for recipe search
  As a logged in user
  I want to select a saved ingredient list
  So that I can search for recipes that can be cooked using those ingredients

  Scenario: Can select previously created ingredient list for recipe search
    Given I am a logged in user
    And I have already created an ingredient list titled "List 1"
    And I am on the user dashboard page
    When I select the ingredient list titled "List 1"
    And I click to search recipes
    Then I should see the recipes that can be cooked using ingredient list titled "List 1"

  Scenario: Doesn't search for the recipe if no ingredient list is selected
    Given I am a logged in user
    And I am on the user dashboard page
    When I click to search recipes
    Then I should be asked to select an ingredient list first
