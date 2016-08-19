# frozen_string_literal: true
require 'fileutils'

Before do
end

After do
  Dir["#{__dir__}/../../tmp/*"]
    .reject { |dir| dir =~ /aruba$/ }
    .each { |dir| FileUtils.rm_rf dir, secure: true }
end
