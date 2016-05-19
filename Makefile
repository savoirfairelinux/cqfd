# Makefile for cqfd

DESTDIR=/usr/local

.PHONY: all help install uninstall tests

all:	help

help:
	@echo "Available make targets:"
	@echo "   help:      This help message"
	@echo "   install:   Install script, doc and resources"
	@echo "   uninstall: Remove script, doc and resources"
	@echo "   tests:     Run functional tests"

install:
	install -d 0755 $(DESTDIR)/bin
	install -m 0755 cqfd $(DESTDIR)/bin/cqfd
	install -d $(DESTDIR)/share/doc/cqfd
	install -m 0644 AUTHORS CHANGELOG LICENSE README.md $(DESTDIR)/share/doc/cqfd/

uninstall:
	rm -rf $(DESTDIR)/bin/cqfd \
		$(DESTDIR)/share/doc/cqfd

tests:
	@make -C tests
