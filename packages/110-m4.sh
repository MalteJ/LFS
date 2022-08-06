#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/m4.html

set -e
set -x

cd /source
tar xvf m4-1.4.19.tar.xz
cd m4-1.4.19


./configure --prefix=/usr
make
make check
make install
