#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/groff.html

set -e
set -x

cd /sources
rm -rf groff-1.22.4
tar xvf groff-1.22.4.tar.gz
cd groff-1.22.4

PAGE=A4 ./configure --prefix=/usr
make -j1
make install
