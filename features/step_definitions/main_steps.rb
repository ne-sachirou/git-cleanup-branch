# frozen_string_literal: true
require 'fileutils'

Before do
end

After do
  Dir["#{__dir__}/../../tmp/*"]
    .reject { |dir| dir =~ %r{\/aruba$} }
    .each { |dir| FileUtils.rm_rf dir, secure: true }
end

Given(/^a process$/) do
  step %{process activity is logged to "greenletters.log"}
  Dir.chdir "#{__dir__}/../../tmp/sample_local"
  step %{a process from command "../../bin/git-cleanup-branch"}
end
