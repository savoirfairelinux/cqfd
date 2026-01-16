#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' accepts running when not in a tty" {
    # the key here is to use /dev/null as stdin
    run echo "$(cqfd run cat /etc/passwd </dev/null)"
    assert_line --regexp "^root:"
}

