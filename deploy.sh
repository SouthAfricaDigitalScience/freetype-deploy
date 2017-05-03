#!/bin/bash -e
# Freetype  deploy script
. /etc/profile.d/modules.sh
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SOURCE_FILE=${NAME}-${VERSION}.tar.gz
# no dependencies for this one...
# but could need png-devel and zlib
#   external zlib: yes (pkg-config)
#  bzip2:         no
#  libpng:        no
#  harfbuzz:      no

module add deploy
module add zlib
module add bzip2
module add libpng

echo "tests have passed, now deploying."
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
# clean out previous configuration
rm -rf *
echo "Setting compiler flags"
export ZLIB_LIBS="-L${ZLIB_DIR}/lib -lz"
export ZLIB_CFLAGS="-I${ZLIB_DIR}/include"
export BZIP2_LIBS="-L${BZLIB_DIR}/lib -lbz2"
export BZIP2_CFLAGS="-I${BZLIB_DIR}/include"

../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes
make
make install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
    puts stderr " needs bzlib, zlib and libpng"
}

module-whatis   "$NAME $VERSION."
setenv       FREETYPE_VERSION      $VERSION
setenv       FREETYPE_DIR                $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(FREETYPE_DIR)/lib
prepend-path PATH                           $::env(FREETYPE_DIR)/bin
prepend-path GCC_INCLUDE_DIR   $::env(FREETYPE_DIR)/include
prepend-path CFLAGS                       "-I$::env(FREETYPE_DIR)/include"
prepend-path LDFLAGS                    "-L$::env(FREETYPE_DIR)/include"
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}

module avail freetype
