build:
	crystal deps
	crystal build --release bin/git-cleanup-branch.cr -o bin/git-cleanup-branch
	chmod +x bin/git-cleanup-branch

init:
	crystal deps
	bundle

test:
	find src spec -name '*.cr' | xargs crystal tool format
	crystal spec
	if hash shellcheck 2> /dev/null ; then shellcheck -s sh bin/create-sample-git-repository.sh ; fi
	bundle exec rubocop
	bundle exec cucumber

# vim: set noet:
