## Emacs, make this -*- mode: sh; -*-

FROM ubuntu

MAINTAINER "Joshua Ulrich" josh.m.ulrich@gmail.com

## install tzdata to avoid stalling image build
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ=America/Chicago
RUN apt-get update && apt-get -y install apt-utils tzdata

## Enable apt sources and get packages
RUN sed 's/^deb /deb-src /g' /etc/apt/sources.list > /etc/apt/sources.list.d/debian-src.list \
  && apt-get update \
  && apt-get build-dep -y r-base-dev \
  && apt-get install -y --no-install-recommends \
    vim-tiny \
    wget \
    subversion \
    rsync \
# rchk
    unzip \
    libcurl4-openssl-dev \
    clang \
    clang-8 \
    clang++-8 \
    llvm \
    llvm-8 \
    llvm-8-dev \
    libllvm8 \
    libc++-dev \
    libc++abi-dev \
    python3-pip \
    qpdf \
    aspell \
    aspell-en \
    libpcre2-dev \
# /rchk
  && rm -rf /var/lib/apt/lists/*

## Install latest WLLVM scripts with pip
RUN pip3 install --upgrade pip \
  && pip3 install wllvm

ENV WLLVM=/usr/local/bin
ENV LLVM=/usr/lib/llvm-8
ENV RCHK=/opt/rchk

## Install rchk
RUN wget https://github.com/kalibera/rchk/archive/master.zip -O /opt/master.zip \
  && unzip /opt/master.zip -d /opt/ \
  && mv /opt/rchk-master/ /opt/rchk/ \
  && cd /opt/rchk/src \
  && make

## Get R-devel source, then configure rchk and build
RUN cd /opt \
  && wget https://stat.ethz.ch/R/daily/R-devel.tar.gz \
  && tar -xf R-devel.tar.gz \
  && mv R-devel R-svn \
  && cd /opt/R-svn/ \
  && /opt/rchk/scripts/build_r.sh

## Check a package
# install package
# . $RCHK/scripts/cmpconfig.inc
# $RCHK/scripts/check_package.sh xts

CMD ["bash"]
