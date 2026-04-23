#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' forwards system SSH config to container when /etc/ssh exists" {
    if [ ! -d "/etc/ssh" ]; then
        skip "/etc/ssh does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' /etc/ssh)

    run cqfd run "stat -c '%d:%i' /etc/ssh"
    assert_success
    assert_line "$host_stat"
}

@test "'cqfd run' disables system SSH config forwarding with CQFD_NO_SSH_CONFIG=true" {
    if [ ! -d "/etc/ssh" ]; then
        skip "/etc/ssh does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' /etc/ssh)

    CQFD_NO_SSH_CONFIG=true \
        run cqfd run "if [ -e /etc/ssh ]; then test \"\$(stat -c '%d:%i' /etc/ssh)\" != '$host_stat'; fi"
    assert_success
}
