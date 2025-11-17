#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd init' with a proper .cqfdrc should pass" {
    cat cqfdrc-test >.cqfdrc
    #shellcheck disable=SC2154
    run cqfd init
    assert_success
}

@test "'cqfd init' with a nonexistent Dockerfile should fail" {
    cp -f .cqfdrc .cqfdrc.old
    sed -i -e "s/\[build\]/[build]\ndistro='thisshouldfail'/" .cqfdrc
    run cqfd init
    assert_failure
}

@test "'cqfd init' with a proper Dockerfile should pass" {
    sed -i -e "s/thisshouldfail/centos/" .cqfdrc
    run cqfd init
    assert_success
    mv -f .cqfdrc.old .cqfdrc
}

@test "'cqfd init' with same uid/gid dummy user should pass" {
    cat <<EOF >>.cqfd/docker/Dockerfile
RUN groupadd -og "${GROUPS[0]}" -f dummy && \
useradd -s /bin/bash -ou "$UID" -g "${GROUPS[0]}" dummy
EOF
    run cqfd init
    assert_success
}

@test "'cqfd init' in quiet mode should be quiet" {
    run cqfd -q init
    assert_line --regexp --index 0 "^(sha256:)?[a-f0-9]{64}$"
    assert_success
}
