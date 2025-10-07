Feature: Add ingredients from search (User story #34)
  As a logged in user
  I want to click on ingredients in the search results
  So that they are added to my ingredient list

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Farmers Market"
    # features/step_definitions/ingredient_list_editor_steps.rb:30
    And the ingredient catalog contains:
      | id  | name         |
      | 101 | Basil        |
      | 202 | Tomato       |
      | 303 | Mozzarella   |

  # features/ingredient_add_user_story_34.feature:15
  Scenario: Selecting an ingredient from search adds it to the list
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Farmers Market" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "Basil"
    # features/step_definitions/ingredient_list_editor_steps.rb:72
    And I select the ingredient "Basil"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    Then the ingredient list titled "Farmers Market" should contain only the following ingredients:
      | Basil |

  # features/ingredient_add_user_story_34.feature:23
  Scenario: Selecting multiple ingredients from search saves them together
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Farmers Market" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:55
    And I search for "o"
    # features/step_definitions/ingredient_list_editor_steps.rb:76
    And I select the ingredients:
      | Tomato     |
      | Mozzarella |
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:93
    Then the ingredient list titled "Farmers Market" should contain only the following ingredients:
      | Tomato     |
      | Mozzarella |
