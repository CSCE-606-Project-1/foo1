Feature: Discard ingredient changes (User story #44)
  As a logged in user
  I want to use the close button in the ingredient editor
  So that I can discard any changes I do not want to keep

  Background:
    Given I am a logged in user
    And I have already created an ingredient list titled "Smoothies"
    And the ingredient list titled "Smoothies" already contains the following ingredients:
      | id  | name   |
      | 901 | Banana |
    And the ingredient catalog contains:
      | id  | name    |
      | 901 | Banana  |
      | 902 | Spinach |

  @javascript
  Scenario: Closing the modal discards newly selected ingredients
    When I open the ingredient list titled "Smoothies" for editing
    And I open the add ingredients modal
    And I type "Spinach" into the ingredient search
    And I pick the ingredient "Spinach" from the results
    And I close the add ingredients modal
    Then the add ingredients modal should be hidden
    And the ingredient list titled "Smoothies" should contain only the following ingredients:
      | Banana |

  @javascript
  Scenario: Closing the modal clears the search field
    When I open the ingredient list titled "Smoothies" for editing
    And I open the add ingredients modal
    And I type "Spinach" into the ingredient search
    And I close the add ingredients modal
    Then the add ingredients modal should be hidden
    And the ingredient search field should be empty
