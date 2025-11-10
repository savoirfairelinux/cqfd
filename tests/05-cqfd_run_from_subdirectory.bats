#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfd can run from a project's sub-directory" {
    pushd "$TDIR" >/dev/null || exit 1
    # Create and enter a dummy sub-directory tree
    sub_dir="dir with space/b/c/d/e"
    mkdir -p "$sub_dir"
    pushd "$sub_dir" >/dev/null || exit 1

    # the two paths should be identical
    p1=$(pwd | strings)
    p2=$(cqfd run pwd | strings)

    run test "$p1" = "$p2"
    assert_success

    # cleanup
    popd >/dev/null || exit 1
    rm -rf "$sub_dir"
}
