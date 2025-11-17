#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd init' without local files should fail" {
    # First, move every local cqfd files into an external directory and use
    # alternate filenames
    extdir="external/dir"
    mkdir -p "$extdir"
    mv .cqfd "$extdir/cqfd"
    mv .cqfdrc "$extdir/cqfdrc"
    cqfd="$BATS_SUITE_TMPDIR/$extdir/cqfd/cqfd"

    run "$cqfd" init
    assert_failure
}

@test "'cqfd init' using alternate filenames in an external directory should work" {
    extdir="external/dir"
    cqfd="$BATS_SUITE_TMPDIR/$extdir/cqfd/cqfd"

    run "$cqfd" -C "$extdir" -d cqfd -f cqfdrc init
    assert_success

    # restore local cqfd files
    mv "$extdir/cqfdrc" .cqfdrc
    mv "$extdir/cqfd" .cqfd
    rmdir -p "$extdir"
}
