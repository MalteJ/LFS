#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/postlfs/efivar.html

set -e
set -x

cd /sources
rm -rf popt-1.18
tar xvf popt-1.18.tar.gz
cd popt-1.18

# Built with instructions from BLFS:

./configure --prefix=/usr --disable-static
make

make install

rm -rf /sources/popt-1.18