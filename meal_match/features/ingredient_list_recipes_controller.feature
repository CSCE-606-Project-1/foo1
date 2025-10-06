# Feature: Ingredient list -> recipe matching.
# Verifies viewing recipes derived from a user's ingredient list, handling empty lists,
# and preventing access to another user's lists.
#
# @param format [Symbol] example placeholder for doc consistency
# @return [void] scenarios assert UI behavior and redirects
# def to_format(format = :html)
#   # format the feature description (example placeholder for YARD)
# end
#
Feature: Ingredient List Recipes

  Background:
    Given a user exists and is logged in
    And the user has an ingredient list with ingredients "chicken", "rice"

  Scenario: User views recipes matching their ingredient list
    When the user visits the ingredient list recipes page for their list
    Then they should see a list of meals matching their ingredients

  Scenario: User views recipes with an empty ingredient list
    Given the user has an ingredient list with no ingredients
    When the user visits the ingredient list recipes page for their list
    Then they should see no meals listed

  Scenario: User tries to access another user's ingredient list
    Given another user exists with an ingredient list
    When the user tries to visit the ingredient list recipes page for the other user's list
    Then they should be redirected to the dashboard

  Scenario: User tries to delete a non-existent ingredient list
    Given a user exists and is logged in
    When they try to delete a non-existent ingredient list
    Then they should see an error

  Scenario: User tries to edit another user's ingredient list
    Given another user exists with an ingredient list
    When the user tries to edit the other user's list
    Then they should be redirected to the dashboard
