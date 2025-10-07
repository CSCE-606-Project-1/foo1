Feature: Return To Dashboard
  As a logged in user
  I want to go back to my user dashboard from any other page within the app
  So that I can quickly navigate back to my dashboard

  Scenario: Directs the user to the dashboard
    Given I am a logged in user
    And I am on the ingredient lists manager page
    When I click to return to dashboard
    Then I should see the user dashboard

  Scenario: Do not ask to return to dashboard when already on dashboard
    Given I am a logged in user
    When I am on the user dashboard page
    Then I should not be asked to return to dashboard

