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

# Freetype  build script
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
# no dependencies for this one...
# but could need png-devel and zlib
#   external zlib: yes (pkg-config)
#  bzip2:         no
#  libpng:        no
#  harfbuzz:      no

module load ci
#module add zlib
# module add bzip2
# module add libpng
module add cmake

mkdir -p ${WORKSPACE}
mkdir -p ${SRC_DIR}
mkdir -p ${SOFT_DIR}

#  Download the source file

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  wget http://sourceforge.net/projects/freetype/files/freetype2/${VERSION}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
tar -xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
# export ZLIB_LIBS="-L${ZLIB_DIR}/lib -lz"
# export ZLIB_CFLAGS="-I${ZLIB_DIR}/include"
# export BZIP2_LIBS="-L${BZLIB_DIR}/lib -lbz2"
# export BZIP2_CFLAGS="-I${BZLIB_DIR}/include"

../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes

make
