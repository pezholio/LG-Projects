Feature: View authority details

  Scenario: Visiting the homepage
    Given I have 2 authorities in the database
    When I visit the homepage
    Then I should see 2 authorities listed

  Scenario: Viewing authority details
    Given an authority "Lichfield Distict Council"
    And that authority has 4 repos
    When I visit the authority page for that authority
    Then I should see that authority's name
    And I should see that authority's avatar
    And I should see 4 repos listed

  Scenario: Viewing additional metadata
    Given an authority "Guilford Borough Council"
    And that authority has a repo called "Test repo" with additional metadata
    When I visit the authority page for that authority
    Then I should see 1 repo listed
    And that page should have the correct metadata listed
