#!/bin/bash -e
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

. /etc/profile.d/modules.sh
module load ci
#module add zlib
module add bzip2
module add libpng
echo ""
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
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
setenv       FREETYPE_DIR                 /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path PATH                            $::env(FREETYPE_DIR)/bin
prepend-path LD_LIBRARY_PATH   $::env(FREETYPE_DIR)/lib
prepend-path LD_LIBRARY_DIR       $::env(FREETYPE_DIR)/include
prepend-path GCC_INCLUDE_DIR   $::env(FREETYPE_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}
