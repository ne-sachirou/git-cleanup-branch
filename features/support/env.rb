# frozen_string_literal: true
require 'aruba/cucumber'
require 'singleton'
require 'tempfile'

Aruba.configure do |config|
  config.home_directory = "#{__dir__}/../../tmp"
end

# Interface of `git-cleanup-branch` command.
class GitCleanupBranch
  include Singleton

  class AlreadyStartedException < StandardError; end
  class YetStartedException < StandardError; end

  attr_reader :input, :output, :pid

  def initialize
    @input = nil
    @output = nil
    @pid = nil
    @pwd = nil
  end

  def start
    raise AlreadyStartedException if @pid
    @pwd = Dir.pwd
    Dir.chdir "#{__dir__}/../../tmp/sample_local"
    @input, @output, @pid = PTY.getpty "#{__dir__}/../../bin/git-cleanup-branch.cr"
    @output.sync = true
    buffer = []
    @input.expect(/Cleanup Git merged branches interactively at both local and remote.+?Cancel/m, 3) do |*lines|
      buffer = buffer.concat lines
    end
    buffer.join ''
  end

  def keypress(chars)
    raise YetStartedException unless @pid
    buffer = []
    chars.each_char do |c|
      @output.write c
      @input.expect(/Cleanup Git merged branches interactively at both local and remote.+?Cancel/m, 1) do |*lines|
        buffer = buffer.concat lines
      end
    end
    buffer.join ''
  end

  def quit
    Process.kill 'KILL', @pid if @pid
    Dir.chdir @pwd if @pwd
    @input = nil
    @output = nil
    @pid = nil
    @pwd = nil
  end
end

def output_cucumber_aruba(content)
  Tempfile.create 'git-cleanup-branch-result' do |file|
    file.write content.gsub(/\e\[\d*./, '').delete("\r").strip
    file.flush
    step %(I run `cat #{file.path}`)
  end
end
