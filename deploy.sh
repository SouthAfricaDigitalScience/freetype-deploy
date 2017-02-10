#!/bin/bash -e
# Freetype  deploy script
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
# no dependencies for this one...
# but could need png-devel and zlib
#   external zlib: yes (pkg-config)
#  bzip2:         no
#  libpng:        no
#  harfbuzz:      no

module load deploy
module add zlib
module add bzip2
module add libpng

echo "tests have passed, now deploying."
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
# clean out previous configuration
rm -rf *
../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes
echo "Setting compiler flags"
export LDFLAGS="-L${ZLIB_DIR}/lib -L${BZLIB_DIR}/lib"
export CFLAGS="-I${ZLIB_DIR}/include -I${BZLIB_DIR}/include"
export CPPFLAGS="-I${ZLIB_DIR}/include -I${BZLIB_DIR}/include"
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

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

module avail freetype
