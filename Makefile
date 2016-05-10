# Makefile for cqfd

.PHONY: all help tests

all:	help

help:
	@echo "Available make targets:"
	@echo "   help:   This help message"
	@echo "   tests:   Run functional tests"

tests:
	@make -C tests
