build:
	crystal build --release bin/git-cleanup-branch.cr
	chmod +x git-cleanup-branch

test:
	find src spec -name '*.cr' | xargs crystal tool format
	crystal spec -v
	bundle exec rubocop
	bundle exec cucumber

# vim: set noet:
