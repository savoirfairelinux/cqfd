#!/usr/bin/env bats

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.init_custom_image .cqfd/docker/Dockerfile
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-custom_image .cqfdrc
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
    custom_img_name="cqfd_test_custom_image_$RANDOM$RANDOM"
    sed -i -e "s!^custom_img_name=.*\$!custom_img_name='$custom_img_name'!" .cqfdrc

    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    run cqfd init
    assert_success
    run cqfd run "true"
    assert_success

    "$cqfd_docker" inspect "$custom_img_name"

    # cleanup
    "$cqfd_docker" rmi "$custom_img_name"
}
