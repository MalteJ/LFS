#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/tar.html

set -e
set -x

cd /sources
rm -rf tar-1.34
tar xvf tar-1.34.tar.xz
cd tar-1.34

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make

#make check

make install
#make -C doc install-html docdir=/usr/share/doc/tar-1.34