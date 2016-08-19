Feature: UI
  Scenario: Show merged branches
    Given a sample git repository
    And run the command and type ""
    Then it should pass with exactly:
      """
      Cleanup Git merged branches at both local and remote.
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
