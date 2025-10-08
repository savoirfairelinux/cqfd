#!/usr/bin/env bats

# Setup so that bats tests can be run from anywhere
setup() {
    # Export to $PATH so that cqfd can be run without ./
    export PATH="$BATS_TEST_DIRNAME/../:$PATH"
}

@test "can run cqfd shell script" {
    cqfd init
    cqfd
}
