#!/usr/bin/env bash

# Version example : 3310100

if [ "$#" -ne 1 ]
then
    echo "Usage:"
    echo "./SQLiteBuilt.sh <VERSION>"
    exit 1
fi

VERSION=$1

DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"


#prepare dir to compile

mkdir ./tmp
mkdir ./tmp/${VERSION}
cd ./tmp/${VERSION}/

#Download sources files from SQLite

curl -OL https://www.sqlite.org/2020/sqlite-autoconf-${VERSION}.tar.gz
tar -xvf sqlite-autoconf-${VERSION}.tar.gz
ls 
cd sqlite-autoconf-${VERSION}

SQLITE_CFLAGS=" \
  -DSQLITE_THREADSAFE=1 \
  -DSQLITE_TEMP_STORE=2 \
"

#---------------------------------------------------------------------------------------------

#Compile for ARMV7
ARCH=armv7
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS=""

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------

#Compile for ARMV7s
ARCH=armv7s
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--verbose \
--with-crypto-lib=commoncrypto \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--disable-editline \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS=""

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------

#Compile for ARM64
ARCH=arm64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--verbose \
--with-crypto-lib=commoncrypto \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--disable-editline \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS=""

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------

#Compile for x86_64
ARCH=x86_64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--verbose \
--with-crypto-lib=commoncrypto \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--disable-editline \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS=""

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------

#LIPO

cd ..
cd ..
cd ..
mkdir ./${VERSION}

lipo -create -output "./${VERSION}/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/armv7/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/armv7s/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/arm64/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/x86_64/libsqlite3.a"

open ./${VERSION}

File ./${VERSION}/libsqlite3.a

#---------------------------------------------------------------------------------------------

#Clean 

rm -r ./tmp

