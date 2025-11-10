#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    test_file="a/cqfd_a.txt"
    if [ -f "$test_file" ]; then
        rm -f "$test_file"
    fi
}

teardown() {
    rm -f "$test_file"
}

@test "running \"cqfd run -c\" makes it run with appended arguments" {
    run cqfd run -c --debug
    assert_line --partial "target 'build'"

    run grep -qw "cqfd" "$test_file"
    assert_success
}

@test "running \"cqfd run -c\" with no argument makes it fail" {
    run cqfd run -c
    assert_failure
}

