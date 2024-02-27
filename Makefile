# Makefile for cqfd

PREFIX?=/usr/local

.PHONY: all help install install-cli-plugin uninstall user-uninstall-cli-plugin test tests

all:	help

help:
	@echo "Available make targets:"
	@echo "   help:      This help message"
	@echo "   install:   Install script, doc and resources"
	@echo "   uninstall: Remove script, doc and resources"
	@echo "   tests:     Run functional tests"

install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 0755 cqfd $(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/share/doc/cqfd/
	install -m 0644 AUTHORS CHANGELOG.md LICENSE README.md $(DESTDIR)$(PREFIX)/share/doc/cqfd/
	install -d $(DESTDIR)$(PREFIX)/share/cqfd/samples/
	install -m 0644 samples/* $(DESTDIR)$(PREFIX)/share/cqfd/samples/
	completionsdir=$${COMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                                                --define-variable=datadir=$(PREFIX)/share \
	                                                --variable=completionsdir \
	                                                bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		install -m 644 bash-completion $(DESTDIR)$$completionsdir/cqfd; \
	fi

install-cli-plugin: DOCKERLIBDIR ?= $(PREFIX)/lib/docker
install-cli-plugin:
	install -D -m 755 docker-cqfd $(DESTDIR)$(DOCKERLIBDIR)/cli-plugins/docker-cqfd

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/bin/cqfd \
		$(DESTDIR)$(PREFIX)/share/doc/cqfd \
		$(DESTDIR)$(PREFIX)/share/cqfd
	completionsdir=$${COMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                                                --define-variable=datadir=$(PREFIX)/share \
	                                                --variable=completionsdir \
	                                                bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		rm -rf $(DESTDIR)$$completionsdir/cqfd; \
	fi

uninstall-cli-plugin: DOCKERLIBDIR ?= $(PREFIX)/lib/docker
uninstall-cli-plugin:
	rm -f $(DESTDIR)$(DOCKERLIBDIR)/cli-plugins/docker-cqfd

user-install user-uninstall user-install-cli-plugin user-uninstall-cli-plugin:
user-%:
	$(MAKE) $* PREFIX=$$HOME/.local BASHCOMPLETIONSDIR=$$HOME/.local/share/bash-completion/completions DOCKERLIBDIR=$$HOME/.docker

test tests:
	@$(MAKE) -C tests
