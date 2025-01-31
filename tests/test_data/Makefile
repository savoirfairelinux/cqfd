.PHONY: all whereami clean build

all:
	@echo "make foo or bar!"

whereami:
	@./whereami.sh

foo:
	@echo making foo
	@echo cqfd >foo

bar:
	@echo making bar
	@echo cqfd >bar

build:
	@mkdir -p a/b/c
	@echo cqfd >a/cqfd_a.txt
	@echo cqfd_b >a/b/cqfd_b.txt
	@echo cqfd_c >a/b/c/cqfd_c.txt

clean:
	@rm -rf foo bar a/
