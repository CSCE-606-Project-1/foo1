Feature: Google Login
  As a user
  I want to sign in with my Google account
  So that I can reuse my google account credentials to access the app

  Scenario: Successful login with Google Account
    Given I am a non logged in user
    And I am on the home page
    When I click to sign in with google
    Then I should see the user dashboard

  Scenario: Do not ask for login to already logged in users
    Given I am a logged in user
    When I am on the home page
    Then I should not be asked to sign in with google
