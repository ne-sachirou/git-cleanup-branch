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
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter " jjj "
    Then the process should exit succesfully
    And the repository has following local branches:
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
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter "jj j "
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
    And a process
    When I execute the process
    And I wait 1 seconds for output from the process
    And I enter " jj jj "
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
