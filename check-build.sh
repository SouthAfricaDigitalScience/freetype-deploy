#!/bin/bash
source /usr/share/modules/init/bash
module load ci
echo ""
cd ${WORKSPACE}/${NAME-$VERSION}
# there is no make check for

echo $?

make install # DESTDIR=$SOFT_DIR

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       FREETYPE_VERSION       $VERSION
setenv       FREETYPE_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(FREETYPE_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(FREETYPE_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}