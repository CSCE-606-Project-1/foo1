Feature: Rename ingredient lists for clarity (User story #33 - naming)
  As a logged in user
  I want to name my ingredient list
  So that I can identify it more easily

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Untitled list"

  # features/ingredient_list_naming_user_story_33.feature:10
  Scenario: User can give an ingredient list a descriptive name
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Untitled list" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:106
    And I rename the ingredient list to "Holiday Baking"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_lists_manager_steps.rb:97
    Then I should see the ingredient list titled "Holiday Baking"

  # features/ingredient_list_naming_user_story_33.feature:16
  Scenario: Leading and trailing spaces are trimmed when saving the name
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Untitled list" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:106
    And I rename the ingredient list to "   Pantry Staples   "
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_lists_manager_steps.rb:97
    Then I should see the ingredient list titled "Pantry Staples"
