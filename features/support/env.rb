# frozen_string_literal: true

require 'aruba/cucumber'
require 'greenletters'
require 'greenletters/cucumber_steps'

def home_directory
  File.expand_path "#{__dir__}/../../tmp"
end

Aruba.configure do |config|
  config.home_directory = home_directory
end

# # Monkey patch for NCurses & Termbox.
# module Greenletters
#   # Monkey patch for NCurses & Termbox.
#   class Process
#     # Monkey patch for NCurses & Termbox.
#     def process_output(handle)
#       @logger.debug "output ready #{handle.inspect}"
#       data = handle.readpartial(1024).gsub(/\e\[.*?[A-Za-z]/, '')
#       output_buffer << data
#       @history << data
#       @logger.debug format_input_for_log(data)
#       @logger.debug "read #{data.size} bytes"
#       handle_triggers(:bytes)
#       handle_triggers(:output)
#       flush_triggers!(OutputTrigger) if ended?
#       flush_triggers!(BytesTrigger) if ended?
#     end
#   end
#
#   # Monkey patch for NCurses & Termbox.
#   module CucumberHelpers
#     def greenletters_massage_pattern(text)
#       Regexp.new(Regexp.escape(text.strip.tr_s(" \r\n\t", ' ')).gsub('\ ', '[\b\s]+'))
#     end
#   end
# end
