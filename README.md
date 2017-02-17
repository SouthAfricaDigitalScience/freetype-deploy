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
export LDFLAGS="-L${ZLIB_DIR}/lib -L${BZLIB_DIR}/lib -lz -lbz2"
export CFLAGS="-I${ZLIB_DIR}/include -I${BZLIB_DIR}/include"
export CPPFLAGS="-I${ZLIB_DIR}/include -I${BZLIB_DIR}/include"
../configure  \
--prefix=${SOFT_DIR} \
--with-zlib=yes \
--with-bzip2=yes \
--with-png=yes
```


# Citing
