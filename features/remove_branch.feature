Feature: Remove branch
  Scenario: Create a sample repository
    Given a sample git repository
    Then the repository has following local branches:
      |                 |
      | master          |
      | sample_merged   |
      | sample_unmerged |
    And the repository has following remote branches:
      |                        |
      | origin/master          |
      | origin/sample_merged   |
      | origin/sample_unmerged |

  Scenario: Remove a local merged branch
    Given a sample git repository
    And start the command
    And type " jjj " to the UI
    Then the repository has following local branches:
      |                 |
      | master          |
      | sample_unmerged |
    And the repository has following remote branches:
      |                        |
      | origin/master          |
      | origin/sample_merged   |
      | origin/sample_unmerged |

  Scenario: Remove a remote merged branch
    Given a sample git repository
    And start the command
    And type "jj j " to the UI
    Then the repository has following local branches:
      |                 |
      | master          |
      | sample_merged   |
      | sample_unmerged |
    And the repository has following remote branches:
      |                        |
      | origin/master          |
      | origin/sample_unmerged |

  Scenario: Cancel to remove branches
    Given a sample git repository
    And start the command
    And type " jj jj " to the UI
    Then the repository has following local branches:
      |                 |
      | master          |
      | sample_merged   |
      | sample_unmerged |
    And the repository has following remote branches:
      |                        |
      | origin/master          |
      | origin/sample_merged   |
      | origin/sample_unmerged |
