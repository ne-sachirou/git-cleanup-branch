# frozen_string_literal: true
require 'expect'
require 'pty'

Given(/^a sample git repository$/) do
  step %(I run `bin/create-sample-git-repository.sh 1>&2 /dev/null`)
end
