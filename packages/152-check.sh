#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/check.html

set -e
set -x

cd /sources
rm -rf check-0.15.2
tar xvf check-0.15.2.tar.gz
cd check-0.15.2

./configure --prefix=/usr --disable-static
make
make check
make docdir=/usr/share/doc/check-0.15.2 install
