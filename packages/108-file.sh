#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/file.html

set -e
set -x

cd /sources
rm -rf file-5.41
tar xzvf file-5.41.tar.gz
cd file-5.41


./configure --prefix=/usr
make
make check
make install
