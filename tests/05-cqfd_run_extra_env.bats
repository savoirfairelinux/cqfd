#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' passes environment variables to the container when using CQFD_EXTRA_RUN_ARGS" {
    val1="value-$RANDOM"
    val2="value-$RANDOM"
    # shellcheck disable=SC2016
    CQFD_EXTRA_RUN_ARGS="-e FOO=$val1 -e BAR=$val2" \
        run cqfd run 'echo -n $FOO $BAR'
    assert_line "$val1 $val2"
}

