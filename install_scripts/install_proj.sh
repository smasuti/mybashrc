#!/usr/bin/env bash

PACKAGES=$HOME/mysoft/packages/

mkdir -p $HOME/mysoft
mkdir -p $PACKAGES
mkdir -p $HOME/mysoft/src

# Installing the proj library
SOURCE_DIR=$HOME/src
PROJ_DIR=$HOME/mysoft/packages/proj

mkdir -p $SOURCE_DIR
pushd $SOURCE_DIR 

curl http://download.osgeo.org/proj/proj-4.9.3.tar.gz > proj.tar.gz
gunzip proj.tar.gz
tar -xf proj.tar

CFLAGS=-fPIC FCFLAGS=-fPIC ./configure --prefix=$HOME/mysoft/packages/proj
if [ $? == 0 ]; then
    clear
    echo "Configuarion is successful"
fi
CFLAGS=-fPIC FCFLAGS=-fPIC make
if [ $? == 0 ]; then
    clear
    echo "Compilation is successful"
fi
make install
if [ $? == 0 ]; then
    clear
    echo "PROJ is installed"
fi
popd

