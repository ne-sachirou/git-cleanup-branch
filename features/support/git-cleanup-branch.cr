#!/usr/bin/env crystal
require "./ncurses"
require "../src/git_cleanup_branch"

if STDIN.tty?
  STDIN.raw { GitCleanupBranch::App.new.start }
else
  GitCleanupBranch::App.new.start
end
