.PHONY: tests check

tests: CQFD_DOCKER =
tests: CQFD_EXTRA_RUN_ARGS =
tests: CQFD_EXTRA_BUILD_ARGS =
tests: CQFD_EXTRA_RMI_ARGS =
tests: CQFD_NO_SSH_CONFIG =
tests: CQFD_NO_SSH_AUTH_SOCK =
tests: CQFD_NO_USER_SSH_CONFIG =
tests: CQFD_NO_USER_GIT_CONFIG =
tests: CQFD_BIND_DOCKER_SOCK =
tests: CQFD_DOCKER_GID =
tests: CQFD_SHELL =
tests:
	./bats/bin/bats --jobs 8 --no-parallelize-across-files ./

check:
	shellcheck -x [0-9][0-9]*
