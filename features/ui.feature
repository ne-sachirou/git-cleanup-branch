Feature: UI
  Scenario: Show merged branches
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >  sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """

  Scenario: Down and up the cursor
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter "j"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
         sample_merged
      Remote
      >  origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """
    When I enter "k"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >  sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """

  Scenario: Select and deselect an option
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter " "
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >* sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """
    When I enter " "
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >  sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """

  Scenario: Select multiple options
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter " j j"
    And I discard earlier outputs from the process
    And I enter " "
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
       * sample_merged
      Remote
       * origin/master
      >* origin/sample_merged
      - - -
         Remove branches
         Cancel
      """

  Scenario: Up the cursor too much
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter "j"
    And I discard earlier outputs from the process
    And I enter "k"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >  sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """
    When I enter "k"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >  sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
         Cancel
      """

  Scenario: Down the cursor too much
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter "jjj"
    And I discard earlier outputs from the process
    And I enter "j"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
         sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
      >  Cancel
      """
    When I enter "j"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
         sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
      >  Cancel
      """

  Scenario: Cancel the command
    Given a sample git repository
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter "jjjj"
    And I discard earlier outputs from the process
    And I enter "j"
    Then I should see the following output:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
         sample_merged
      Remote
         origin/master
         origin/sample_merged
      - - -
         Remove branches
      >* Cancel
      """
    And the process should exit succesfully
