#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/patch.html

set -e
set -x

cd /sources
rm -rf patch-2.7.6
tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/usr
make
make check
make install
