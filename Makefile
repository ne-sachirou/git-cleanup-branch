.PHONY: help build build_darwin build_linux build_linux_app build_termbox clean install fix test uninstall
default: build
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'


build: ## Build a release binary
	$(MAKE) build_linux
	$(MAKE) build_darwin

build_darwin:
	crystal deps --production
	$(MAKE) build_termbox
	bash -eux build.darwin-x86_64.sh
	cp bin/git-cleanup-branch bin/git-cleanup-branch-darwin-x86_64
	sandbox-exec -f test.darwin-x86_64.sb bin/git-cleanup-branch --help

build_linux:
	docker build -f Dockerfile.build.linux-x86_64 -t git-cleanup-branch.build.linux-x86_64 .
	docker run -v $(shell pwd):/data git-cleanup-branch.build.linux-x86_64 make build_linux_app
	mv bin/git-cleanup-branch bin/git-cleanup-branch-linux-x86_64
	docker build -f Dockerfile.test.linux-x86_64 -t git-cleanup-branch.test.linux-x86_64 .
	docker run git-cleanup-branch.test.linux-x86_64 git-cleanup-branch --help

build_linux_app:
	crystal deps --production
	$(MAKE) build_termbox
	crystal build --release -o bin/git-cleanup-branch --link-flags '-static' bin/git-cleanup-branch.cr

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
	rm -f bin/git-cleanup-branch bin/git-cleanup-branch.o bin/git-cleanup-branch-darwin-x86_64 bin/git-cleanup-branch-linux-x86_64

fix: ## Fix lint automatically
	find bin src spec -type f -name '*.cr' -exec crystal tool format {} \;
	bundle exec rubocop -a

install: ## cp the binary to PATH
	cp bin/git-cleanup-branch /usr/local/bin/

test: ## Test
	shellcheck -e SC2046,SC2148 Makefile
	find . bin -depth 1 -name '*.sh' -exec shellcheck -s sh {} \;
	find bin src spec -name '*.cr' -exec crystal tool format --check {} \;
	crystal deps
	crystal spec
	bundle
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
