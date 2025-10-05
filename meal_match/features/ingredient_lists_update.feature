# frozen_string_literal: true
Feature: Ingredient list update error handling
  As a logged-in user
  I want the system to handle invalid and failed updates gracefully

  Background:
    Given controller: a user exists and is logged in
    And controller: an ingredient list exists titled "MyList"

  Scenario: IngredientList update raises ActiveRecord::RecordInvalid
    Given controller: IngredientList update! raises ActiveRecord::RecordInvalid
    When controller: I submit a PATCH request to update that ingredient list
    Then controller: I should be redirected to the ingredient list show page
    And controller: I should see "can't be blank"

  Scenario: IngredientList update raises a generic StandardError
    Given controller: IngredientList update! raises a generic StandardError
    When controller: I submit a PATCH request to update that ingredient list
    Then controller: I should be redirected to the ingredient list show page
    And controller: I should see "We couldn't save your ingredient list"
