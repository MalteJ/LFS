#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/make.html

set -e
set -x

cd /sources
rm -rf make-4.3
tar xvf make-4.3.tar.gz
cd make-4.3

./configure --prefix=/usr

make

make check

make install