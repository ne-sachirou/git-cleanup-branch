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

# Monkey patch for NCurses.
module Greenletters
  # Monkey patch for NCurses.
  module CucumberHelpers
    def greenletters_massage_pattern(text)
      Regexp.new(Regexp.escape(text.strip.tr_s(" \r\n\t", ' ')).gsub('\ ', '[\b\s]+'))
    end
  end
end
