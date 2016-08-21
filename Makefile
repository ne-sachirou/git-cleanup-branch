build:
	crystal build --release bin/git-cleanup-branch.cr
	chmod +x git-cleanup-branch

init:
	crystal deps
	bundle

test:
	find src spec -name '*.cr' | xargs crystal tool format
	crystal spec -v
	shellcheck bin/create-sample-git-repository.sh
	bundle exec rubocop
	bundle exec cucumber features --format pretty

# vim: set noet:
