#!/usr/bin/env bats

setup_file() {
    mv -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-docker_run_image .cqfdrc
    export docker_run_image="ubuntu:16.04"
    #shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$docker_run_image"; then
        "$cqfd_docker" rmi "$docker_run_image"
    fi
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "'cqfd' does not pull image" {
    run cqfd
    assert_failure
}

@test "'cqfd init' pulls image" {
    run cqfd init
    assert_success
    run "$cqfd_docker" inspect "$docker_run_image"
    assert_success
}

@test "'cqfd' uses pulled image" {
    run cqfd
    assert_success
    assert_line --regexp "Ubuntu 16.04(.[[:digit:]]+)? LTS"
}
