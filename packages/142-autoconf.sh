#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/autoconf.html

set -e
set -x

cd /source
rm -rf autoconf-2.71
tar xvf autoconf-2.71.tar.xz
cd autoconf-2.71

./configure --prefix=/usr
make
make check
make install