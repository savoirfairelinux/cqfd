#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    flavor="foo"
}

@test "cqfd run build cmd for 'foo' flavor" {
    test_file=$flavor
    run cqfd -b "$flavor" run
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "cqfd run and override with additional cmd" {
    test_file="file.$RANDOM"
    run cqfd -b "$flavor" run touch "$test_file"
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
}
