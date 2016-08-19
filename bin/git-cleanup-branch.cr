#!/usr/bin/env crystal run
require "../src/git_cleanup_branch"

GitCleanupBranch::App.new.start
