#! /bin/bash

# checks package for rchk tools 
#
PKG=$1

cd /opt/R-svn
/opt/rchk/scripts/check_package.sh ${PKG}

cp packages/lib/${PKG}/libs/*check /opt
cat /opt/*bcheck
