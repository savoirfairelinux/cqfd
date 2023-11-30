.PHONY: tests check

tests:
	@$(eval TDIR=$(shell mktemp -d))
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
	if echo $(TDIR) | grep -q "/tmp/tmp\.[a-zA-Z]"; then \
		rm -rf $(TDIR); \
	fi; \
	if [ "$$failed" = "1" ]; then \
		echo "Failures occured"; \
		exit 1; \
	fi

check:
	shellcheck -x jtest.inc [0-9][0-9]*
