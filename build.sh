#!/bin/bash -e
source /usr/share/modules/init/bash

SOURCE_FILE=${NAME}-${VERSION}.tar.gz
# no dependencies for this one...
# but could need png-devel and zlib
#   external zlib: yes (pkg-config)
#  bzip2:         no
#  libpng:        no
#  harfbuzz:      no


module load ci
echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [[ ! -e $SRC_DIR/$SOURCE_FILE ]] ; then
  echo "seems like this is the first build - let's get the source"
  mkdir -p $SRC_DIR
  wget http://sourceforge.net/projects/freetype/files/freetype2/${VERSION}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi
tar -xvz --keep-newer-files -f ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}
cd ${WORKSPACE}/${NAME}-${VERSION}
./configure --prefix ${SOFT_DIR}
make
