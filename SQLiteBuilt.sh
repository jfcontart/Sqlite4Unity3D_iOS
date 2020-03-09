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
rm -r ./sqlite
mkdir ./${VERSION}

#Download sources files from SQLCipher

curl -OL https://www.sqlite.org/2020/sqlite-autoconf-${VERSION}.tar.gz
tar -xvf ./sqlite-autoconf-${VERSION}.tar.gz ./sqlite3

#Compile

xcodebuild -target sqlite_builder -project sqlite3.xcodeproj

#copy result

#cp ./tmp/${VERSION}/sqlite-autoconf-${VERSION}/.libs/libsqlite3.0.dylib ./${VERSION}/
#open ./${VERSION}

#Clean 

#rm -r ./sqlite/*


