Feature: Logout from Meal Match

  Scenario: Successful logout from meal match
    Given I am a logged in user
    And I am on the home page
    When I click to log out
    Then I should see the login page
