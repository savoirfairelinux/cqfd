#!/usr/bin/env bats
# validate the behavior with skelton bring up

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

################################################################################
# running 'cqfd images' without a proper config and empty cache should succeed
################################################################################
@test "'cqfd images' runs without an .cqfdrc and with an empty cache" {
    run cqfd images
    assert_success
}

################################################################################
# running 'cqfd prune' without a proper config and empty cache should succeed
################################################################################
@test "'cqfd prune' runs without an .cqfdrc and with an empty cache" {
    run cqfd prune
    assert_success
}

################################################################################
# running 'cqfd init' should fail, as there's no proper config
################################################################################
@test "create a test skeleton in temporary directory" {
    run cqfd init
    assert_failure
}

################################################################################
# running 'cqfd init' should fail, as there's an empty config
################################################################################
@test "cqfd init complains with an empty .cqfdrc" {
    touch .cqfdrc
    run cqfd init
    assert_failure
}

################################################################################
# running 'cqfd init' should fail, as there's an incomplete config
################################################################################
@test "cqfd init complains with an incomplete .cqfdrc" {
    echo '[project]' >.cqfdrc
    run cqfd init
    assert_failure
}
