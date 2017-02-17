[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=freetype-deploy)](https://ci.sagrid.ac.za/job/freetype-deploy/)

# freetype-deploy

Build and test scripts necessary to deploy freetype libraries and headers, for CODE-RADE


# Versions

We build :

  * 2.7.1

# Dependencies

  * bzlib
  * zlib
  * libpng

# Configuration

```
export ZLIB_LIBS="-L${ZLIB_DIR}/lib -lz"
export ZLIB_CFLAGS="-I${ZLIB_DIR}/include"
export BZIP2_LIBS="-L${BZIP_DIR}/lib -lbz2"
export BZIP2_CFLAGS="-I${BZIP_DIR}/include"
../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes
```


# Citing
