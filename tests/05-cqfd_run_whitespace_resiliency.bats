#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' passes environment variables to the container when using CQFD_EXTRA_RUN_ARGS with an option containing a whitespace" {
    CQFD_EXTRA_RUN_ARGS="-e FOO=bar\ baz" run cqfd run env
    assert_line "FOO=bar baz"
}

@test "'cqfd run' passes environment variables to the container when using docker_run_args with an option containing a whitespace" {
    # setup -- add the docker_run_args option to config
    sed '/\[build\]/adocker_run_args="-e FOO=bar\\ baz"' -i .cqfdrc
    run cqfd run env
    assert_line --partial "FOO=bar baz"
    # teardown -- clear the docker_run_args option from config
    sed '/\[build\]/{n;d}' -i .cqfdrc
}
