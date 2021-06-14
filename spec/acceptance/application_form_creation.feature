Feature: Creating application forms
  Background:
    Given settings with submission deadlines exists
    And I am eligible user

  Scenario: I see application links on dashboard
    When I go to dashboard
    Then I should see application link

  Scenario: I'm able to create nomination
    When I create nomination
    Then I should see nomination form
    And I should see application edit link on dashboard
