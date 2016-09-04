# frozen_string_literal: true
require 'aruba/cucumber'
require 'greenletters'
require 'greenletters/cucumber_steps'


Aruba.configure do |config|
  config.home_directory = "#{__dir__}/../../tmp"
end
