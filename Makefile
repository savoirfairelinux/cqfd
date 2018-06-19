# Makefile for cqfd

PREFIX?=/usr/local

.PHONY: all help install uninstall tests

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
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		install -m 644 bash-completion $(DESTDIR)$$completionsdir/cqfd; \
	fi

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/bin/cqfd \
		$(DESTDIR)$(PREFIX)/share/doc/cqfd \
		$(DESTDIR)$(PREFIX)/share/cqfd
	completionsdir=$$(pkg-config --variable=completionsdir bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		rm -rf $(DESTDIR)$$completionsdir/cqfd; \
	fi

tests:
	@make -C tests
