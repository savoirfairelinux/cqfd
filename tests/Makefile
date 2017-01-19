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
	@$(eval TDIR=$(shell mktemp -d /tmp/cqfd-test.XXXXXX))
	@for f in [0-9][0-9]*; do \
		if [ -x "$$f" ]; then \
			./$$f $(TDIR); \
		fi; \
	done; \
	failed=0; \
	if [ -f $(TDIR)/.jtest_results ]; then \
		echo " --- Test results ---"; \
		cat "$(TDIR)"/.jtest_results; \
		echo " --------------------"; \
		if grep -q "FAIL" "$(TDIR)"/.jtest_results; then \
			failed=1; \
		fi; \
	fi; \
	if echo $(TDIR) | grep -q "/tmp/cqfd-test\.[0-9a-zA-Z]{6,6}"; then \
		rm -rf $(TDIR); \
	fi; \
	if [ "$$failed" = "1" ]; then \
		echo "Failures occured"; \
		exit 1; \
	fi

check:
	shellcheck -x jtest.inc [0-9][0-9]*
