#!/usr/bin/env bats

setup_file() {
    cp -f .cqfdrc .cqfdrc.old
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
}

@test "cqfdrc does not strip semicolons in command" {
    sed -i -e "/[build]/,/^$/s,^command=.*$,command='true; echo \"It works!\"'," .cqfdrc

    run cqfd init
    assert_success

    run cqfd
    assert_line "It works!"
}
