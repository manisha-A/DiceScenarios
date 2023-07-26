Feature: This feature tests that mio user can create event on MIO platform

  Scenario Outline: Create and publish an event as MIO user
    Given I am on MIO website
    And I am logged in to MIO as mio user
    When I create a new event
    And I enter <genre> and <venue_name> for event details
    And I fill in event timeline
    And I fill in event information
    And I add <ticket_allocation> tickets
    And I save event and continue
    And I submit event
    Then the event should be published

    Examples:
      | genre      | venue_name           | ticket_allocation |
      | deep house | DICE VENUE in London | 2                 |