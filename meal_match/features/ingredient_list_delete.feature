Feature: Delete Ingredient List
  As a logged in user
  I should be able to delete my created ingredient list
  So that I can keep my ingredient lists organized

  Scenario: Successful deletion of ingredient list
    Given I am a logged in user
    And I have already created an ingredient list titled "List 1"
    And I am on the ingredient lists manager page
    When I click to delete the ingredient list titled "List 1"
    Then I should no longer see the ingredient list titled "List 1" in the ingredient lists table

  Scenario: All lists have been deleted
    Given I am a logged in user
    And I have already created a few ingredient lists
    And I am on the ingredient lists manager page
    When I click to delete all ingredient lists
    Then I should not see a table of ingredient lists
