#!/usr/bin/env bats

setup_file() {
    mv -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-external_docker_image .cqfdrc
    export external_docker_image="ubuntu:22.04"
    #shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$external_docker_image"; then
        "$cqfd_docker" rmi "$external_docker_image"
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
    run "$cqfd_docker" inspect "$external_docker_image"
    assert_success
}

@test "'cqfd' uses pulled image" {
    run cqfd
    assert_success
    assert_line --regexp "Ubuntu 22.04(.[[:digit:]]+)? LTS"
}
