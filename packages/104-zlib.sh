#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/zlib.html

set -e
set -x

cd /source
tar xvf zlib-1.2.11.tar.xz
cd zlib-1.2.11

./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libz.a
