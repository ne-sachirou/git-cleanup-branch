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
  process = case `uname -s`.chomp
            when 'Darwin' then 'git-cleanup-branch-darwin-x86_64'
            when 'Linux' then 'git-cleanup-branch-linux-x86_64'
            else raise 'Unknown platform'
            end
  Dir.chdir "#{home_directory}/sample_local" do
    step %(a process from command "#{home_directory}/../bin/#{process}")
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
