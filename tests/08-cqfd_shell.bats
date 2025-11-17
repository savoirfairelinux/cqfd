#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    unset CQFD_SHELL
}

@test "cqfd shell should succeed with no stdin" {
    run cqfd shell </dev/null
    assert_success
}

@test "cqfd shell should read commands from stdin" {
    run cqfd shell <<<"tty"
    assert_line "not a tty"
}

@test "cqfd shell should preserve the arguments" {
    # shellcheck disable=SC2016
    run cqfd shell -c 'printf "0=$0,*=$*,#=$#"' zero one two three
    assert_line "0=zero,*=one two three,#=3"
}

@test "cqfd shell should fail with 127 and '/bin/non-existant-shell: command not found'" {
    bats_require_minimum_version 1.5.0
    CQFD_SHELL=/bin/non-existant-shell run -127 cqfd shell <<<"tty" 
    assert_line --regexp "/bin/non-existant-shell: (command )?not found"
    assert_failure 127
}

@test "cqfd sh should succeed and use sh" {
    # shellcheck disable=SC2016
    run cqfd sh <<<'printf "$0"'
    assert_line "sh"
}

@test "cqfd bash should succeed and use bash" {
    # shellcheck disable=SC2016
    run cqfd bash <<<'printf "$0"'
    assert_line "bash"
}

@test "cqfd dash should succeed and use dash" {
    # shellcheck disable=SC2016
    run cqfd dash <<<'printf "$0"'
    assert_line "dash"
}

@test "cqfd fish should fail with 127 and 'fish: command not found'" {
    bats_require_minimum_version 1.5.0
    # shellcheck disable=SC2016
    run -127 cqfd fish <<<'printf "$0"'
    assert_line --regexp "fish: (command )?not found"
    assert_failure 127
}

@test "cqfd shell is usable to run shell script" {
    run cqfd shell ./whereami.sh
    assert_line --regexp '^Ubuntu .* LTS$'
}

@test "cqfd bash is usable to run shell script" {
    run cqfd bash ./whereami.sh
    assert_line --regexp '^Ubuntu .* LTS$'
}

@test "cqfd shell is usable as a shell interpreter script" {
    #shellcheck disable=SC2030
    PATH="$BATS_SUITE_TMPDIR/.cqfd:$PATH"
    run ./whereami.sh
    assert_line --regexp '^Ubuntu .* LTS$'
}

@test "cqfd shell is usable as a shell interpreter in binaries" {
    if command -v make; then
        #shellcheck disable=SC2031
        PATH="$BATS_SUITE_TMPDIR/.cqfd:$PATH" run make whereami
        assert_line --regexp '^Ubuntu .* LTS$'
    fi
}
