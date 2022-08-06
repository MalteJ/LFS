#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/diffutils.html

set -e
set -x

cd /sources
rm -rf diffutils-3.8
tar xvf diffutils-3.8.tar.xz
cd diffutils-3.8

./configure --prefix=/usr
make
make check
make install
