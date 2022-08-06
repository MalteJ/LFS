#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/man-db.html

set -e
set -x

cd /sources
rm -rf man-db-2.10.1
tar xvf man-db-2.10.1.tar.xz
cd man-db-2.10.1

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.10.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=

make
make check
make install