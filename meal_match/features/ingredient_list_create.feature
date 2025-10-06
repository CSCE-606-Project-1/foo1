Feature: Create Ingredient List

  Scenario: Successful creation of Ingredient List
    Given I am a logged in user
    And I am on the ingredient lists manager page
    And I have already created a few ingredient lists
    When I click to create a new ingredient list
    Then I should see the newly created ingredient list below the previously created lists

  Scenario: Newly created list should have a default title
    Given I am a logged in user
    And I am on the ingredient lists manager page
    When I click to create a new ingredient list
    Then I should see the newly created list with the default title "Untitled list"
