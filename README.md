[![Build Status](https://travis-ci.org/ne-sachirou/git-cleanup-branch.svg?branch=master)](https://travis-ci.org/ne-sachirou/git-cleanup-branch)

git-cleanup-branch
==
Small utility to cleanup Git merged branches _interactively_ at both local and remote.

Installation
--
Supported platforms:

- OS X
- Linux

Download a binary from [releases](https://github.com/ne-sachirou/git-cleanup-branch/releases).

Or build it by yourself. Latest [Crystal](https://crystal-lang.org/) & libncurses is required.

```sh
git clone https://github.com/ne-sachirou/git-cleanup-branch.git
cd git-cleanup-branch
make
```

Usage
--
```sh
cd git_project
git-cleanup-branch
```

![demo](demo.gif)

TODO
--
- [ ] Windows support.
