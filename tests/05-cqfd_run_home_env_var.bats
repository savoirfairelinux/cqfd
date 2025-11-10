#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cqfd_docker="${CQFD_DOCKER:-docker}"
}

@test "'cqfd run' sets HOME environment variable for the local user" {
    cp -f .cqfdrc .cqfdrc.old
    # shellcheck disable=SC2016
    run cqfd run 'echo -n $HOME'
    assert_line "$HOME"
}

@test "'cqfd run' does not override HOME environment explicitly set via CQFD_EXTRA_RUN_ARGS" {
    val1="value-$RANDOM"
    val2="value-$RANDOM"
    # shellcheck disable=SC2016
    CQFD_EXTRA_RUN_ARGS="-e FOO=$val1 -e HOME=$val2" run cqfd run 'echo -n $FOO $HOME'
    assert_line "$val1 $val2"
}

@test "'cqfd run' does not override HOME environment when it is the only entry in CQFD_EXTRA_RUN_ARGS" {
    val1="value-$RANDOM"
    # shellcheck disable=SC2016
    CQFD_EXTRA_RUN_ARGS="-e HOME=$val1" run cqfd run 'echo -n $FOO $HOME'
    assert_line "$val1"
}

@test "'cqfd run' does not confuse JAVA_HOME and the like with HOME when set via CQFD_EXTRA_RUN_ARGS" {
    val1="value-$RANDOM"
    val2="value-$RANDOM"
    # shellcheck disable=SC2016
    CQFD_EXTRA_RUN_ARGS="-e JAVA_HOME=$val1 -e HOME=$val2" run cqfd run 'echo -n $JAVA_HOME $HOME'
    assert_line "$val1 $val2"
}


@test "The container's user directory has been created with the right home directory." {
    if [ "$cqfd_docker" != "podman" ]; then
        passwd_home=$(cqfd run "grep ^$(whoami): /etc/passwd |cut -d: -f6")
        user_home=$(cqfd run "echo \$HOME")
        run [ "$passwd_home" = "$user_home" ]
        assert_success
    fi
}


@test "'cqfd run' does not override HOME environment explicitly set via docker_run_args" {
    val1="value-$RANDOM"
    val2="value-$RANDOM"
    cat .cqfdrc.old - <<EOF >.cqfdrc
docker_run_args="--env FOO=$val1 --env HOME=$val2"
EOF
    # shellcheck disable=SC2016
    run cqfd run 'echo -n $FOO $HOME'
    assert_line "$val1 $val2"
}

@test "'cqfd run' does not override HOME environment when it is the only entry in docker_run_args" {
    val1="value-$RANDOM"
    cat .cqfdrc.old - <<EOF >.cqfdrc
docker_run_args="--env HOME=$val1"
EOF
    # shellcheck disable=SC2016
    run cqfd run 'echo -n $FOO $HOME'
    assert_line "$val1"
}

@test "'cqfd run' does not confuse JAVA_HOME and the like with HOME when set via docker_run_args" {
    val1="value-$RANDOM"
    val2="value-$RANDOM"
    cat .cqfdrc.old - <<EOF >.cqfdrc
docker_run_args="--env JAVA_HOME=$val1 --env HOME=$val2"
EOF
    # shellcheck disable=SC2016
    run cqfd run 'echo -n $JAVA_HOME $HOME'
    assert_line "$val1 $val2"
    # restore .cqfdrc
    mv -f .cqfdrc.old .cqfdrc
}

