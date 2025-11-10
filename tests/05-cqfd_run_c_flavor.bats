#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    flavor="foo"
    test_file="$flavor"
    if [ -f "$test_file" ]; then
        rm -f "$test_file"
    fi
}

teardown() {
    rm -f "$test_file"
}

@test "build cmd for 'foo' flavor and concatenate with an additional option" {
    run cqfd -b "$flavor" run -c --debug
    assert_line --partial "target 'foo'"
    run grep -w "cqfd" "$test_file"
    assert_success
}
