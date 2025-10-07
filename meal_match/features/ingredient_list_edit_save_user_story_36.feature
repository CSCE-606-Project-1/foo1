Feature: Save ingredient list edits (User story #36)
  As a logged in user
  I want to save the edits I make to my ingredient list
  So that the latest ingredients are retained

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Meal Prep"
    # features/step_definitions/ingredient_list_editor_steps.rb:30
    And the ingredient catalog contains:
      | id  | name     |
      | 301 | Chicken  |
      | 302 | Broccoli |
      | 303 | Rice     |
    # features/step_definitions/ingredient_list_editor_steps.rb:41
    And the ingredient list titled "Meal Prep" already contains the following ingredients:
      | id  | name    |
      | 301 | Chicken |

  # features/ingredient_list_edit_save_user_story_36.feature:18
  Scenario: Saving after replacing one ingredient with another persists the change
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Meal Prep" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "Broccoli"
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Chicken"
    # features/step_definitions/ingredient_list_editor_steps.rb:72
    And I select the ingredient "Broccoli"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    Then the ingredient list titled "Meal Prep" should contain only the following ingredients:
      | Broccoli |

  # features/ingredient_list_edit_save_user_story_36.feature:27
  Scenario: Saving multiple edits keeps the most recent selection
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Meal Prep" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "Rice"
    # features/step_definitions/ingredient_list_editor_steps.rb:72
    And I select the ingredient "Rice"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    And I open the ingredient list titled "Meal Prep" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "Broccoli"
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Chicken"
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Rice"
    # features/step_definitions/ingredient_list_editor_steps.rb:72
    And I select the ingredient "Broccoli"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    Then the ingredient list titled "Meal Prep" should contain only the following ingredients:
      | Broccoli |
