default: build

build:
	crystal deps
	crystal build --release bin/git-cleanup-branch.cr -o bin/git-cleanup-branch
	chmod +x bin/git-cleanup-branch

init:
	crystal deps
	bundle

install:
	cp bin/git-cleanup-branch /usr/local/bin/

test:
	find src spec -name '*.cr' | xargs crystal tool format
	crystal spec
	if hash shellcheck 2> /dev/null ; then shellcheck -s sh bin/create-sample-git-repository.sh ; fi
	bundle exec rubocop
	rm -f greenletters.log
	bundle exec cucumber

uninstall:
	rm -f /usr/local/bin/git-cleanup-branch

# vim: set noet:
