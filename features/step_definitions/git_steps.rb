# frozen_string_literal: true

Given(/^a sample git repository$/) do
  step %{I run `bin/create-sample-git-repository.sh 1>&2 /dev/null`}
end

Then(/^the repository has following local branches:$/) do |expected|
  Dir.chdir "#{home_directory}/sample_local" do
    actual = `git branch`.each_line.collect { |line| line.sub(/\A[\s*]+/, '').strip }
    expected = expected.rows.flat_map { |row| row[0] }
    expect(actual).to contain_exactly(*expected)
  end
end

Then(/^the repository has following remote branches:$/) do |expected|
  Dir.chdir "#{home_directory}/sample_local" do
    actual = `git branch -r`.each_line.reject { |line| line.include? ' -> ' }.collect(&:strip)
    expected = expected.rows.flat_map { |row| row[0] }
    expect(actual).to contain_exactly(*expected)
  end
end
