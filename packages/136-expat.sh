#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/expat.html

set -e
set -x

cd /sources
rm -rf expat-2.4.6
tar xvf expat-2.4.6.tar.xz
cd expat-2.4.6

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.6

make
make check
make install

## docs:
# install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.6
