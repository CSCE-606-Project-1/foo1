Feature: Ingredient search (User story #11)
  As a logged in user
  I want to search for ingredients
  So that I can add them to my ingredient list

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Weekly Staples"
    # features/step_definitions/ingredient_list_editor_steps.rb:30
    And the ingredient catalog contains:
      | id  | name            |
      | 111 | Chicken Breast  |
      | 222 | Chickpeas       |
      | 333 | Carrot          |

  # features/ingredient_search_user_story_11.feature:15
  Scenario: Searching for ingredients returns matching results
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Weekly Staples" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "chick"
    # features/step_definitions/ingredient_list_editor_steps.rb:60
    Then I should see the ingredient search results:
      | Chicken Breast |
      | Chickpeas      |

  # features/ingredient_search_user_story_11.feature:22
  Scenario: Searching for ingredients with no matches shows a helpful message
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Weekly Staples" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "dragonfruit"
    # features/step_definitions/ingredient_list_editor_steps.rb:68
    Then I should see a message that no ingredients were found
