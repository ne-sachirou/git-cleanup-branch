.PHONY: help build build_darwin build_linux build_linux_app build_termbox clean install fix test travis uninstall
default: build
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'


build: ## Build a release binary
	$(MAKE) build_linux
ifeq ($(shell uname -s),Darwin)
	$(MAKE) build_darwin
endif

build_darwin:
	crystal deps --production
	$(MAKE) build_termbox
	crystal build.darwin-x86_64.cr
	otool -L bin/git-cleanup-branch-darwin-x86_64
	sandbox-exec -f test.darwin-x86_64.sb bin/git-cleanup-branch-darwin-x86_64 --help

build_linux:
	docker build -f Dockerfile.build.linux-x86_64 -t git-cleanup-branch.build.linux-x86_64 .
	docker run --rm -v $(shell pwd):/data git-cleanup-branch.build.linux-x86_64 make build_linux_app
	docker build -f Dockerfile.test.linux-x86_64 -t git-cleanup-branch.test.linux-x86_64 .
	docker run --rm git-cleanup-branch.test.linux-x86_64 git-cleanup-branch --help

build_linux_app:
	crystal deps --production
	$(MAKE) build_termbox
	crystal build --release -o bin/git-cleanup-branch-linux-x86_64 --link-flags '-static' bin/git-cleanup-branch.cr

build_termbox:
	cd lib/termbox \
	&& (ls lib-termbox || git clone --depth=1 https://github.com/nsf/termbox lib-termbox) \
	&& cd lib-termbox \
	&& git pull \
	&& ./waf configure --prefix=/usr/local \
	&& ./waf clean \
	&& ./waf \
	&& ./waf install --destdir=/

clean: ## Clean
	rm -f bin/git-cleanup-branch-darwin-x86_64.o bin/git-cleanup-branch-darwin-x86_64 bin/git-cleanup-branch-linux-x86_64

fix: ## Fix lint automatically
	find bin src spec -type f -name '*.cr' -exec crystal tool format {} \;
	bundle exec rubocop -a

install: ## cp the binary to PATH
ifeq ($(shell uname -s),Linux)
	cp bin/git-cleanup-branch-linux-x86_64 /usr/local/bin/git-cleanup-branch
endif
ifeq ($(shell uname -s),Darwin)
	cp bin/git-cleanup-branch-darwin-x86_64 /usr/local/bin/git-cleanup-branch
endif

test: ## Test
	find . bin -depth 1 -name '*.sh' -exec shellcheck -s sh {} \;
	find bin src spec -name '*.cr' -exec crystal tool format --check {} \;
	crystal spec
	bundle exec rubocop
	rm -f greenletters.log
	bundle exec cucumber

travis:
	cd lib/termbox \
	&& git clone --depth=1 https://github.com/nsf/termbox lib-termbox \
	&& cd lib-termbox \
	&& ./waf configure --prefix=$(HOME) \
	&& ./waf \
	&& ./waf install --destdir=/
	LIBRARY_PATH=$(HOME)/lib:$(LIBRARY_PATH) LD_LIBRARY_PATH=$(HOME)/lib:$(LD_LIBRARY_PATH) crystal spec

uninstall: ## rm the installed binary
	rm -f /usr/local/bin/git-cleanup-branch
