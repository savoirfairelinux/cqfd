#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' forwards system git config to container when /etc/gitconfig exists" {
    # Skip this test if /etc/gitconfig doesn't exist on the system
    if [ ! -f "/etc/gitconfig" ]; then
        skip "/etc/gitconfig does not exist on this system"
    fi

    # Verify that the system git config is accessible inside the container
    run cqfd run 'test -f /etc/gitconfig'
    assert_success
}

@test "'cqfd run' disables system git config forwarding with CQFD_NO_SYSTEM_GIT_CONFIG=true" {
    # Skip this test if /etc/gitconfig doesn't exist on the system
    if [ ! -f "/etc/gitconfig" ]; then
        skip "/etc/gitconfig does not exist on this system"
    fi

    # Verify that the system git config is not accessible when disabled
    CQFD_NO_SYSTEM_GIT_CONFIG=true \
        run cqfd run 'test ! -f /etc/gitconfig'
    assert_success
}
