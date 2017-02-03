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
  step %(process activity is logged to "greenletters.log")
  Dir.chdir "#{home_directory}/sample_local" do
    step %(a process from command "#{home_directory}/../bin/git-cleanup-branch")
  end
end

When(/^I wait ([\d.]+) seconds$/) do |seconds|
  sleep seconds.to_f
end

# Monkey patch for NCurses & Termbox.
When(/^I keypress "([^\"]*)"(?: into process "([^\"]*)")?$/) do |input, name|
  name ||= 'default'
  @greenletters_process_table[name] << input
end
