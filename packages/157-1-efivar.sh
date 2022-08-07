#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/postlfs/efivar.html

set -e
set -x

cd /sources
rm -rf efivar-38
tar xvf efivar-38.tar.bz2
cd efivar-38

# Built with instructions from BLFS:

sed '/prep :/a\\ttouch prep' -i src/Makefile
make
make install LIBDIR=/usr/lib


rm -rf /sources/efivar-38