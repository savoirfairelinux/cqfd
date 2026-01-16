#!/usr/bin/env bats

setup_file() {
    export BATS_NO_PARALLELIZE_WITHIN_FILE=true
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    flavor="foo"
}

@test "'cqfd init' with different flavor makes a different container" {
    cp -f .cqfdrc .cqfdrc.old
    sed -i -e "s/\[foo\]/[foo]\ndistro='centos'/" .cqfdrc
    run cqfd -b "$flavor" init
    assert_success
    run cqfd -b "$flavor" run "grep '^NAME=' /etc/*release"
    assert_line --partial "NAME=\"CentOS Linux\""
}

@test "'cqfd init' with invalid flavor should fail" {
    flavorPart="${flavor:0:2}"
    run cqfd -b "$flavorPart" init
    assert_failure
}

@test "'cqfd init' without flavor generates our regular container" {
    mv -f .cqfdrc.old .cqfdrc
    run cqfd init
    assert_success
    run cqfd run "grep '^NAME=' /etc/*release"
    assert_line --partial "NAME=\"Ubuntu\""
}
