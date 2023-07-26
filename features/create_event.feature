Feature: This feature tests something
  Scenario: Create and Submit an event as MIO user
    Given I am logged in to MIO as mio user
    When I create a new event
    And I enter event details
    Then this should happen