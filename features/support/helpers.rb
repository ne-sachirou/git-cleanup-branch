# frozen_string_literal: true
require 'tempfile'

def output_cucumber_aruba(content)
  Tempfile.create 'git-cleanup-branch-result' do |file|
    file.write content.gsub(/\e\[\d*./, '').delete("\r").strip
    file.flush
    step %(I run `cat #{file.path}`)
  end
end
