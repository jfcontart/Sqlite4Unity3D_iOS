#!/usr/bin/env bash

# Version example : 3310100

if [ "$#" -ne 1 ]
then
    echo "Usage:"
    echo "./SQLiteBuilt.sh <VERSION>"
    exit 1
fi

VERSION=$1

#prepare dir to compile

cd ./

#Download sources files from SQLCipher

curl -OL https://www.sqlite.org/2020/sqlite-autoconf-${VERSION}.tar.gz
tar -xvf ./sqlite-autoconf-${VERSION}.tar.gz
rm -r ./sqlite/*
mkdir ./${VERSION}
mv ./sqlite-autoconf-${VERSION}/sqlite3.c ./sqlite/sqlite3.c
mv ./sqlite-autoconf-${VERSION}/sqlite3.h ./sqlite/sqlite3.h
mv ./sqlite-autoconf-${VERSION}/sqlite3ext.h ./sqlite/sqlite3ext.h
rm ./sqlite-autoconf-${VERSION}.tar.gz
rm -r ./sqlite-autoconf-${VERSION}/*
rm -r ./sqlite-autoconf-${VERSION}

#Compile

xcodebuild -target "sqlite_builder" -configuration "Release"

#copy result

cp ./delivery/IOS/Release_sqlite3/sqlite3Library/iPhoneUniversal/libsqlite3.a ./${VERSION}/libsqlite3.a
open ./${VERSION}

#Clean 

rm -r ./delivery/*
rm -r ./delivery


