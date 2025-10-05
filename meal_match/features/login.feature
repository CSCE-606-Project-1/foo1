Feature: Google Login

  Scenario: Successful login with Google Account
    Given I am a non logged in user
    And I am on the home page
    When I click to sign in with google
    Then I should see the user dashboard
