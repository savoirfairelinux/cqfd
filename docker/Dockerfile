FROM ubuntu:14.04


ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV HOME /home/builder


RUN apt-get update && apt-get install -y --no-install-recommends \
	asciidoc \
	autogen \
	automake \
	bc \
	bison \
	build-essential \
	ca-certificates \
	dblatex \
	docbook-xml \
	dosfstools \
	flex \
	gawk \
	gettext \
	git \
	kpartx \
	lib32stdc++6 \
	lib32z1 \
	libc6-dev-i386 \
	libncurses5-dev \
	libreadline-dev \
	libtool \
	libxml2-utils \
	parted \
	pv \
	python \
	rsync \
	screen \
	ssh \
	subversion \
	unzip \
	w3m \
	wget \
	zip \
	zlib1g-dev \
	&& locale-gen $LANG $LC_ALL && update-locale $LANG $LC_ALL


WORKDIR /home/builder/src
VOLUME /home/builder/src

