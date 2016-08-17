build:
	find src -name '*.cr' | xargs crystal tool format
	crystal build --release bin/git-cleanup-branch.cr
	chmod +x git-cleanup-branch

test:
	crystal spec

# vim: set noet:
