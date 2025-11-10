#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfdrc fails if no project section" {
    cp -f .cqfdrc .cqfdrc.old
    echo -n "" >.cqfdrc
    run cqfd
    assert_line "cqfd: fatal: .cqfdrc: Missing project section!"
}

@test "cqfdrc fails if no name property set in project section" {
    echo "[project]" >>.cqfdrc
    run cqfd
    assert_line "cqfd: fatal: .cqfdrc: Missing project.org or project.name properties"
}

@test "cqfdrc fails if no org property set in project section" {
    echo "name=test" >>.cqfdrc
    run cqfd
    assert_line "cqfd: fatal: .cqfdrc: Missing project.org or project.name properties"
}

@test "cqfdrc fails if no build section" {
    echo "org=cqfd" >>.cqfdrc
    run cqfd
    assert_line "cqfd: fatal: .cqfdrc: Missing build section!"
}

@test "cqfdrc fails if no command property set in build section" {
    echo "[build]" >>.cqfdrc
    run cqfd
    assert_line "cqfd: fatal: .cqfdrc: Missing or empty build.command property"
}

@test "cqfdrc succeeds if project and build sections are set correctly" {
    cqfd init
    run cqfd run true
    assert_success
}

@test "cqfdrc succeeds even if no command property set in build section using run -c" {
    run cqfd run -c true
    assert_line "cqfd: warning: .cqfdrc: Missing or empty build.command property"
}

@test "cqfdrc succeeds if command property set in build section using run -c" {
    run cqfd run -c true
    assert_line "cqfd: warning: .cqfdrc: Missing or empty build.command property"
}

@test "cqfdrc with tabulation before should pass" {
    cp -f .cqfdrc.old .cqfdrc
    echo "foo	=bar" >>.cqfdrc
    run cqfd run true
    assert_success
}

@test "cqfdrc with tabulation after should pass" {
    cp -f .cqfdrc.old .cqfdrc
    echo "foo=	bar" >>.cqfdrc
    run cqfd run true
    assert_success
}

@test "cqfdrc with space before should pass" {
    cp -f .cqfdrc.old .cqfdrc
    echo "foo =bar" >>.cqfdrc
    run cqfd run true
    assert_success
}

@test "cqfdrc with space after should pass" {
    cp -f .cqfdrc.old .cqfdrc
    echo "foo= bar" >>.cqfdrc
    run cqfd run true
    assert_success
    mv -f .cqfdrc.old .cqfdrc
}

