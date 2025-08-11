#!/usr/bin/env bats

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd with custom image works" {
    custom_image_1="cqfd_test_custom_image_1_$RANDOM$RANDOM"

    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$custom_image_1"; then
        "$cqfd_docker" rmi "$custom_image_1"
    fi
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
    echo "FROM ubuntu:24.04" >.cqfd/docker/Dockerfile

    run cqfd init
    assert_success
    run cqfd run "true"
    assert_success

    "$cqfd_docker" inspect "$custom_image_1"

    # cleanup
    "$cqfd_docker" rmi "$custom_image_1"
}
