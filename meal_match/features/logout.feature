Feature: Logout from Meal Match
  As a user
  I want to sign out from my meal match account
  So that I can securely leave the app

  Scenario: Successful logout from meal match
    Given I am a logged in user
    And I am on the home page
    When I click to log out
    Then I should see the login page

  Scenario: Do not ask to logout from the login page
    Given I am a non logged in user
    When I am on the home page
    Then I should see the login page
    And I should not be asked to logout
