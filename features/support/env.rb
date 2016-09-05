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
