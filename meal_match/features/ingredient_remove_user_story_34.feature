Feature: Remove selected ingredients (User story #34)
  As a logged in user
  I want to click on selected ingredients
  So that I can remove them from my ingredient list

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Stir Fry"
    # features/step_definitions/ingredient_list_editor_steps.rb:41
    And the ingredient list titled "Stir Fry" already contains the following ingredients:
      | id  | name   |
      | 501 | Ginger |
      | 502 | Garlic |
    # features/step_definitions/ingredient_list_editor_steps.rb:30
    And the ingredient catalog contains:
      | id  | name   |
      | 501 | Ginger |
      | 502 | Garlic |

  # features/ingredient_remove_user_story_34.feature:18
  Scenario: Deselecting an ingredient removes it after saving
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Stir Fry" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Ginger"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    Then the ingredient list titled "Stir Fry" should contain only the following ingredients:
      | Garlic |

  # features/ingredient_remove_user_story_34.feature:25
  Scenario: Removing all ingredients leaves the list empty
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Stir Fry" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Ginger"
    # features/step_definitions/ingredient_list_editor_steps.rb:80
    And I deselect the ingredient "Garlic"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:101
    Then the ingredient list titled "Stir Fry" should have no ingredients
