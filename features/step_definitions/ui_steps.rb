# frozen_string_literal: true
require 'tempfile'

class PtyExitException < StandardError; end

Given(/^run the command and type "([^"]*)" then exit$/) do |type|
  buffer = ''
  Dir.chdir 'tmp/sample_local' do
    begin
      PTY.getpty '../../bin/git-cleanup-branch.cr' do |input, output|
        output.sync = true
        input.expect(/^Cleanup Git merged branches at both local and remote.+  Cancel/m, 3) { |*lines| buffer += lines.join '' }
        type.split('').each do |c|
          output.write c
          input.expect(/Cleanup Git merged branches at both local and remote.+  Cancel/m, 1) { |*lines| buffer += lines.join '' }
        end
        raise PtyExitException
      end
    rescue PtyExitException
      nil
    end
  end
  Tempfile.create 'git-cleanup-branch-result' do |file|
    file.write buffer.gsub(/\e\[\d*./, '').delete("\r")
    file.flush
    step %(I run `cat #{file.path}`)
  end
end
