# frozen_string_literal: true

Given(/^start the command$/) do
  content = GitCleanupBranch.instance.start
  output_cucumber_aruba content
end

Given(/^type "([^"]*)" to the UI$/) do |chars|
  content = GitCleanupBranch.instance.keypress chars
  output_cucumber_aruba content
end

Then(/^the command should have quited$/) do
  status = PTY.check GitCleanupBranch.instance.pid
  expect(status.exited?).to be_truthy
  expect(status.success?).to be_truthy
end
