#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    test_file="a/cqfd_a.txt"
    if [ -f "$test_file" ]; then
        rm -f "$test_file"
    fi
}

@test "running \"cqfd\" with no argument makes it run" {
    run cqfd
    assert_success
    run grep -qw "cqfd" "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "running \"cqfd run\" makes it run" {
    run cqfd run
    assert_success
    run grep -qw "cqfd" "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "Modifying the Dockerfile should require running 'cqfd init' again" {
    dockerfile=.cqfd/docker/Dockerfile
    echo "RUN echo $RANDOM" >>"$dockerfile"
    run cqfd run
    assert_failure
    # restore Dockerfile
    sed -i '$d' "$dockerfile"
}
