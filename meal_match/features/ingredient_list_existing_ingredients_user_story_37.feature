Feature: View existing ingredients in a list (User story #37)
  As a logged in user
  I want to see the ingredients already saved in my list
  So that I know what is currently included

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Salad Bowls"

  # features/ingredient_list_existing_ingredients_user_story_37.feature:10
  Scenario: Existing ingredients are shown when editing the list
    # features/step_definitions/ingredient_list_editor_steps.rb:41
    And the ingredient list titled "Salad Bowls" already contains the following ingredients:
      | id  | name   |
      | 401 | Lettuce |
      | 402 | Tomato  |
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Salad Bowls" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:119
    Then the ingredient list should show the selected ingredients:
      | Lettuce |
      | Tomato  |

  # features/ingredient_list_existing_ingredients_user_story_37.feature:20
  Scenario: Lists with no saved ingredients indicate an empty selection
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Salad Bowls" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:127
    Then the ingredient list should indicate that no ingredients are selected
