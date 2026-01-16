#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    getent_cmd="getent hosts 1.2.3.4"
}

@test "run cqfd without extra hosts" {
    bats_require_minimum_version 1.5.0
    run [ "$(cqfd run "$getent_cmd")" = "" ]
    assert_success
}

@test "run cqfd with extra hosts" {
    CQFD_EXTRA_RUN_ARGS="--add-host testhost:1.2.3.4" run cqfd run "$getent_cmd"
    assert_line --regexp "1.2.3.4.*testhost"
}

@test "run cqfd with docker_run_args in config" {
    # setup -- add the docker_run_args option to config
    sed '/\[build\]/adocker_run_args="--add-host testhost:1.2.3.4"' -i .cqfdrc
    run cqfd run "$getent_cmd"
    assert_line --regexp "1.2.3.4.*testhost"

    # teardown -- clear the docker_run_args option from config
    sed '/\[build\]/{n;d}' -i .cqfdrc
}


