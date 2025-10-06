Feature: Created Ingredient list remains saved across user logins

  Scenario: Saved Ingredient List persists between logins
    Given I am a logged in user
    And I am on the ingredient lists manager page
    And I have already created an ingredient list titled "List 1"
    When I click to log out
    And I click to sign in with google
    And I am on the ingredient lists manager page
    Then I should see the ingredient list titled "List 1"
