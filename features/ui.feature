Feature: UI
  Scenario: Show merged branches
    Given a sample git repository
    And start the command
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >   sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """

  Scenario: Down and up the cursor
    Given a sample git repository
    And start the command
    And type "j" to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
          sample_merged
      Remote
      >   origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """
    And type "k" to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >   sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """

  Scenario: Select and deselect an option
    Given a sample git repository
    And start the command
    And type " " to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      > * sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """
    And type " " to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >   sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """

  Scenario: Select multiple options
    Given a sample git repository
    And start the command
    And type " j j" to the UI
    And type " " to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
        * sample_merged
      Remote
        * origin/master
      > * origin/sample_merged
      - - -
          Remove branches
          Cancel
      """

  Scenario: Up the cursor too much
    Given a sample git repository
    And start the command
    And type "j" to the UI
    And type "k" to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >   sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """
    Given type "k" to the UI
    Then it should pass with exactly:
      """
      Cleanup Git merged branches interactively at both local and remote.
      ==
      Local
      >   sample_merged
      Remote
          origin/master
          origin/sample_merged
      - - -
          Remove branches
          Cancel
      """

  Scenario: Down the cursor too much
    Given a sample git repository
    And start the command
    And type "jjj" to the UI
    And type "j" to the UI
    Then it should pass with exactly:
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
      >   Cancel
      """
    Given type "j" to the UI
    Then it should pass with exactly:
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
      >   Cancel
      """

  Scenario: Cancel the command
    Given a sample git repository
    And start the command
    And type "jjjj" to the UI
    And type " " to the UI
    Then it should pass with exactly:
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
      > * Cancel
      """
    And the command should have quited
