Feature: Ingredient list management
  As a user who manages ingredient lists
  I want to access the ingredient list interface
  So that I can add ingredients to my lists

  Background:
    Given a user exists with email "user@example.com"
    And I am logged in as "user@example.com"

  Scenario: Viewing the ingredient list page
    When I visit the ingredient list page
    Then I should see the add ingredients button
