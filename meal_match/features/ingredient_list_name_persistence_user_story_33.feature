Feature: Persist ingredient list name across sessions (User story #33)
  As a logged in user
  I want the ingredient list name I choose to be saved
  So that I can access it from any device when I log in

  Background:
    # features/step_definitions/login_logout_steps.rb:27
    Given I am a logged in user
    # features/step_definitions/ingredient_lists_manager_steps.rb:33
    And I have already created an ingredient list titled "Default Title"

  # features/ingredient_list_name_persistence_user_story_33.feature:10
  Scenario: A renamed ingredient list keeps its name after logging out and in
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Default Title" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:106
    And I rename the ingredient list to "Family Favorites"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/login_logout_steps.rb:34
    And I click to log out
    # features/step_definitions/login_logout_steps.rb:13
    And I click to sign in with google
    # features/step_definitions/ingredient_lists_manager_steps.rb:19
    And I am on the ingredient lists manager page
    # features/step_definitions/ingredient_lists_manager_steps.rb:97
    Then I should see the ingredient list titled "Family Favorites"

  # features/ingredient_list_name_persistence_user_story_33.feature:19
  Scenario: A renamed list shows the saved name when editing again later
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    When I open the ingredient list titled "Default Title" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:106
    And I rename the ingredient list to "Weeknight Dinners"
    # features/step_definitions/ingredient_list_editor_steps.rb:84
    And I save the ingredient list
    # features/step_definitions/ingredient_list_editor_steps.rb:49
    And I open the ingredient list titled "Weeknight Dinners" for editing
    # features/step_definitions/ingredient_list_editor_steps.rb:114
    Then the ingredient list name field should contain "Weeknight Dinners"
