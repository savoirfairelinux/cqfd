#!/usr/bin/env bats

setup_file() {
    export BATS_NO_PARALLELIZE_WITHIN_FILE=true
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.missing_dependencies .cqfd/docker/Dockerfile
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd run fails when the Docker image lacks required commands" {
    bats_require_minimum_version 1.5.0
    run cqfd init
    assert_success
    run cqfd run
    assert_failure
}

@test "cqfd run with satisfied command requirements, using su" {
    echo 'RUN apk add bash shadow' >>.cqfd/docker/Dockerfile
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "su"'
}

@test "cqfd run with satisfied command requirements, using sudo" {
    echo 'RUN apk add sudo' >>.cqfd/docker/Dockerfile
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "sudo"'
}
