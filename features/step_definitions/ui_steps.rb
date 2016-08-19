# frozen_string_literal: true
require 'tempfile'

class PtyExitException < StandardError; end

Given(/^run the command and type "([^"]*)"$/) do |type|
  Tempfile.create 'git-cleanup-branch-result' do |file|
    Dir.chdir 'tmp/sample_local' do
      begin
        PTY.getpty '../../bin/git-cleanup-branch.cr' do |input, output|
          output.sync = true
          input.expect(/^Cleanup Git merged branches at both local and remote\..+  Cancel$/m, 3) do |*lines|
            file.write lines.join('').gsub("\r\r\n", "\n")
            output.write type
            raise PtyExitException
          end
        end
      rescue PtyExitException
        nil
      end
    end
    file.flush
    step %(I run `cat #{file.path}`)
  end
end
