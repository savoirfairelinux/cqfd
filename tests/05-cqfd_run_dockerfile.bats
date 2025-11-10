#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfd run using a Dockerfile with entrypoint should success" {
    # backup Dockerfile
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    cat <<EOF >>.cqfd/docker/Dockerfile
ENTRYPOINT ["false"]
EOF
    run cqfd init
    assert_success
    run cqfd run
    assert_success
    # restore Dockerfile
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
    cqfd init
}
