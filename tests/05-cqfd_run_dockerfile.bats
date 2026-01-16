#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
    # backup Dockerfile
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    # restore Dockerfile
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
    cqfd init
}

@test "cqfd run using a Dockerfile with entrypoint should success" {
    cat <<EOF >>.cqfd/docker/Dockerfile
ENTRYPOINT ["false"]
EOF
    run cqfd init
    assert_success
    run cqfd run
    assert_success
}
