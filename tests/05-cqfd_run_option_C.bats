#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd -C <dir>' runs the command from that directory" {
    pushd "$BATS_SUITE_TMPDIR" >/dev/null || exit 1
    sub_dir="sub/dir"
    mkdir -p "$sub_dir"
    pushd "$sub_dir" >/dev/null || exit 1

    p1=$(cd ../.. && pwd | strings)
    p2=$(cqfd -C ../.. run pwd | strings)

    run test "$p1" = "$p2"
    assert_success

    popd >/dev/null || exit 1
    rm -rf "sub"
}
