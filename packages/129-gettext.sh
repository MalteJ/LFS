#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/gettext.html

set -e
set -x

cd /sources
rm -rf gettext-0.21
tar xvf gettext-0.21.tar.xz
cd gettext-0.21

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21

make
make check
make install

chmod -v 0755 /usr/lib/preloadable_libintl.so
