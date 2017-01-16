.PHONY: help build init install test uninstall
default: build

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'

build: ## Build a release binary
	crystal deps
	crystal build --release bin/git-cleanup-branch.cr -o bin/git-cleanup-branch

init: ## Install pre-requirements
	crystal deps
	bundle

install: ## cp the binary to PATH
	cp bin/git-cleanup-branch /usr/local/bin/

test: ## Test
	find src spec -name '*.cr' | xargs crystal tool format
	crystal spec
	if hash shellcheck 2> /dev/null ; then shellcheck -s sh bin/create-sample-git-repository.sh ; fi
	bundle exec rubocop
	rm -f greenletters.log
	bundle exec cucumber

uninstall: ## rm the installed binary
	rm -f /usr/local/bin/git-cleanup-branch

# vim: set noet:
