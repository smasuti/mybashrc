#!/usr/bin/env bash

PACKAGES=$HOME/mysoft/packages/

mkdir -p $HOME/mysoft
mkdir -p $PACKAGES
# Installing the proj library


# Installing the fftw library
mkdir -p $HOME/mysoft/fftw/
pushd  $PACKAGES 
curl http://www.fftw.org/fftw-3.3.7.tar.gz > fftw.tar.gz
gunzip fftw.tar.gz
tar -xvf fftw.tar
pushd fftw
CFLAGS=-fPIC FCFLAGS=-fPIC ./configure --prefix=$HOME/mysoft/fftw/ --enable-threads --enable-float --enable-sse
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
    echo "FFTW is installed"
fi
popd 
popd 



 
