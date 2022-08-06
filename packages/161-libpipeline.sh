#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/libpipeline.html

set -e
set -x

cd /source
rm -rf libpipeline-1.5.5
tar xvf libpipeline-1.5.5.tar.gz
cd libpipeline-1.5.5

./configure --prefix=/usr
make
make check
make install
