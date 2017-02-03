#!/bin/bash -eux
CLANG_TARGET=$(clang -v 2>&1 | awk '/^Target:/{print $2}')
CC_CMD=$(crystal build --release -o bin/git-cleanup-branch --cross-compile --target "$CLANG_TARGET" bin/git-cleanup-branch.cr | perl -pe 's#-l(\w+)#`ls /usr/local/lib/lib$1.a 2>/dev/null` ? "/usr/local/lib/lib$1.a" : "-l$1"#ge')
$CC_CMD
