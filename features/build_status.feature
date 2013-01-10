Feature: Showing the build status
  Scenario: All is good
    When all the builds are green
    Then I should see the amalgamated response is green

  Scenario: A build has failed
    When there are some failed builds
    Then I should see the amalgamated response is red

