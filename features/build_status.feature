Feature: Showing the build status
  Scenario: All is good
    When all the builds are green
    Then I should see the amalgamated response is green

