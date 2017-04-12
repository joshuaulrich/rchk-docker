## Emacs, make this -*- mode: sh; -*-
 
FROM r-base:latest

MAINTAINER "Joshua Ulrich" josh.m.ulrich@gmail.com

## Enable apt sources and get packages
RUN sed 's/^deb /deb-src /g' /etc/apt/sources.list > /etc/apt/sources.list.d/debian-src.list \
  && apt-get update \
  && apt-get build-dep -y r-base-dev \
  && apt-get install -y --no-install-recommends \
    vim-tiny \
    wget \
# rchk
    libcurl4-openssl-dev \
    clang-3.8 \
    llvm-3.8-dev \
    clang\+\+-3.8 \
    clang \
    llvm-dev \
    python-pip \
# /rchk
  && rm -rf /var/lib/apt/lists/*

## Install latest WLLVM scripts from GitHub
RUN pip install --upgrade pip \
  && pip install setuptools wheel --upgrade \
  && wget https://github.com/travitch/whole-program-llvm/archive/master.zip -O /opt/master.zip \
  && unzip /opt/master.zip -d /opt/ \
  && mv /opt/whole-program-llvm-master /opt/whole-program-llvm \
  && pip install wllvm --user /opt/whole-program-llvm-master

## Install rchk
RUN wget https://github.com/kalibera/rchk/archive/master.zip -O /opt/master.zip \
  && unzip /opt/master.zip -d /opt/ \
  && mv /opt/rchk-master/ /opt/rchk/ \
  && cd /opt/rchk-master/src \
  && make

## Get R sources and configure rchk
RUN mkdir /opt/R-svn/ \
  && svn checkout https://svn.r-project.org/R/trunk /opt/R-svn \
  && export WLLVM=/opt/whole-program-llvm
#  && export LLVM=/var/scratch/tomas/opt/llvm/clang+llvm-3.8.0-x86_64-fedora23
#  && export RCHK=/var/scratch/tomas/opt/rchk

CMD ["bash"]
0
