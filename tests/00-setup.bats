#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

################################################################################
# running 'cqfd init' should fail, as there's no proper config
################################################################################
@test "create a test skeleton in temporary directory" {
    mkdir -p "$TDIR/.cqfd/docker"
    cp -a "$PROJECT_ROOT"/cqfd "$TDIR/.cqfd/"
    cp -a "$PROJECT_ROOT"/tests/test_data/. "$TDIR/."
    run cqfd init
    assert_failure
}

################################################################################
# running 'cqfd init' should fail, as there's an empty config
################################################################################
@test "cqfd init complains with an empty .cqfdrc" {
    touch "$TDIR/.cqfdrc"
    run cqfd init
    assert_failure
}

################################################################################
# running 'cqfd init' should fail, as there's an incomplete config
################################################################################
@test "cqfd init complains with an incomplete .cqfdrc" {
    echo '[project]' >"$TDIR/.cqfdrc"
    run cqfd init
    assert_failure
}
