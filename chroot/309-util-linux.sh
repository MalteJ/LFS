#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter07/util-linux.html

set -e
set -x

cd /sources/
tar xvf util-linux-2.37.4.tar.xz
cd util-linux-2.37.4

mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.37.4 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run

make

make install