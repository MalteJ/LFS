#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/libtool.html

set -e
set -x

cd /source
rm -rf libtool-2.4.6
tar xvf libtool-2.4.6.tar.xz
cd libtool-2.4.6

./configure --prefix=/usr
make
make check
make install

rm -fv /usr/lib/libltdl.a
