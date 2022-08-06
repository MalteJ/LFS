#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter07/Python.html

set -e
set -x

cd /sources/
tar xvf python-3.10.2.tar.xz
cd python-3.10.2

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make

make install