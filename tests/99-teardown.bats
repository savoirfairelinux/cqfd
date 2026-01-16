#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup

    # Make sure all Dockerfiles to be Outdated by editing them
    for doc in .cqfd/*/Dockerfile; do
        test -e "$doc" || continue
	    echo "RUN echo $EPOCHSECONDS" >>"$doc"
    done
}

teardown() {
    # Remove any echo lines we added at the end of the Dockerfiles
    for doc in .cqfd/*/Dockerfile; do
        test -e "$doc" || continue
        sed -i -e '/^RUN echo [0-9]\{9,\}$/d' "$doc"
    done
}

@test "'cqfd images' lists the build containers" {
    run cqfd images
    assert_line --regexp "^cqfd_$USER\_*"
}

@test "'cqfd prune' collects all unused build containers" {
    run cqfd prune
    assert_success

    run cqfd images
    refute_line --regexp "(Deleted|Outdated)"
}

@test "'cqfd images' should not have any build containers at this point" {
    run cqfd images
    refute_line --regexp "(Deleted|Outdated)"
}

@test "'cqfd prune' on an already pruned setup should notify user" {
    run cqfd prune
    assert_line --partial "no unused images"
}
