#!/bin/bash -e
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
module add zlib
module add bzlib
module add libpng

echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

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
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_VERSION}
tar -xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_VERSION}
echo "Setting compiler flags"
export LDFLAGS="-L${ZLIB_DIR}/lib -L${BZLIB_DIR}/lib"
export CFLAGS="-I${ZLIB_DIR}/include -I${BZIP2_DIR}/include"
export CPPFLAGS="-I${ZLIB_DIR}/include -I${BZIP2_DIR}/include"
../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes

make
