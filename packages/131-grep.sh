#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/grep.html

set -e
set -x

cd /source
rm -rf grep-3.7
tar xvf grep-3.7.tar.xz
cd grep-3.7

./configure --prefix=/usr
make
make check
make install
