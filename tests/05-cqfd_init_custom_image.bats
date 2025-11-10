#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cqfd_docker="${CQFD_DOCKER:-docker}"
}

@test "cqfd with custom image works" {
    # create a temporary directory
    TEST_DIR=$(mktemp -d -t cqfd-test-XXXXXX)
    cd "$TEST_DIR" || exit 1
    custom_image_1="cqfd_test_custom_image_1_$RANDOM$RANDOM"

    run "$cqfd_docker" inspect "$custom_image_1"
    assert_failure
    # Test .cqfdrc
    cat >.cqfdrc <<EOF
[project]
org="cqfd"
name="custom-image"
custom_img_name="$custom_image_1"

[build]
command="true"
EOF

    # Test dockerfile
    mkdir -p .cqfd/docker
    echo "FROM ubuntu:24.04" >.cqfd/docker/Dockerfile

    run cqfd init
    assert_success
    run cqfd run "true"
    assert_success

    "$cqfd_docker" inspect "$custom_image_1"
    assert_success

    # cleanup
    "$cqfd_docker" rmi "$custom_image_1"
    rm -rf "$TEST_DIR"
}
