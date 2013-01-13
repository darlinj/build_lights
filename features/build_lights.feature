Feature: Web based feature
  Scenario: Accessing the build status via the web page
    Given all the builds are green
    When I access the root page
    Then I should see green

