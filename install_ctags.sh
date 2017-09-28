#!/usr/bin/env bash

echo "Downloading ctags ... " 
cd Downloads
curl -o http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz
echo "unzipping ... " 
gunzip ctags-5.8.tar.gz
tar -xvf ctags-5.8.tar 
cd ctags-5.8
echo "configuring ... " 
./configure
make 
echo "installing ... " 
make install
cd -
