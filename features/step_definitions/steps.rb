# frozen_string_literal: true
require 'fileutils'

Before do
end

After do
  Dir["#{home_directory}/*"]
    .reject { |dir| dir =~ %r{\/aruba$} }
    .each { |dir| FileUtils.rm_rf dir, secure: true }
end

Given(/^a process$/) do
  step %{process activity is logged to "greenletters.log"}
  Dir.chdir "#{home_directory}/sample_local" do
    step %{a process from command "#{home_directory}/../bin/git-cleanup-branch"}
  end
end
