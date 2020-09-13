#! /bin/bash

# builds package for rchk tools 
#
# the packages have to be installed with cmpconfig.inc included into shell
#   they are placed into packages/lib and their build dirs are kept in packages/build
#
# this script is to be run from the R source directory

# Usage:
#
#   build_package.sh package_tarball
#   package_name can be "all" (by default)
#
# Examples:
#
#   check all packages with default tools:  ./check_package.sh
#   check png package with default tools:   ./check_package.sh png
#   check ggplot2 package with bcheck tool: ./check_package.sh ggplot2 bcheck

PKGARG=$1
PKG_PATH=`readlink -f ${PKGARG}`

cd /opt/R-svn

if [ ! -r $RCHK/scripts/config.inc ] ; then
  echo "Please set RCHK variables (scripts/config.inc)" >&2
  exit 2
fi

. $RCHK/scripts/common.inc

if ! check_config ; then
  exit 2
fi

if [ ! -r ./src/main/R.bin.bc ] ; then
  echo "This script has to be run from the root of R source directory with bitcode files (e.g. src/main/R.bin.bc)." >&2
  exit 2
fi

. $RCHK/scripts/cmpconfig.inc

PKGDIR=$R_LIBS

INSTALL_CMD="./bin/Rscript -e 'install.packages(\"${PKG_PATH}\", lib=\"${R_LIBS}\", repos=NULL)'"

eval ${INSTALL_CMD}

exit 0
