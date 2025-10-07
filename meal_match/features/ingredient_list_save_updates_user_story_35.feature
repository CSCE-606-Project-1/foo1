Feature: Save ingredient list updates (User story #35)
  As a logged in user
  I want to save updates to my ingredient list
  So that my changes are persisted

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Pizza Night"
    # features/step_definitions/ingredient_list_editor_steps.rb:30
    And the ingredient catalog contains:
      | id  | name       |
      | 801 | Pepperoni  |
      | 802 | Mushrooms  |

  # features/ingredient_list_save_updates_user_story_35.feature:14
  Scenario: Saving updates shows a confirmation message
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Pizza Night" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "Pepperoni"
    # features/step_definitions/ingredient_list_editor_steps.rb:72
    And I select the ingredient "Pepperoni"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/full_user_flow_steps.rb:13
    Then I should see "Ingredient list saved successfully"
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    And the ingredient list titled "Pizza Night" should contain only the following ingredients:
      | Pepperoni |

  # features/ingredient_list_save_updates_user_story_35.feature:23
  Scenario: Saving a renamed list updates the title in the manager
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Pizza Night" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:106
    And I rename the ingredient list to "Friday Pizza Party"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:110
    Then I should be on the ingredient lists manager page
    # features/step_definitions/ingredient_lists_manager_steps.rb:97
    And I should see the ingredient list titled "Friday Pizza Party"
