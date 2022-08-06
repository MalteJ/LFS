#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/procps-ng.html

set -e
set -x

cd /source
rm -rf procps-ng-3.3.17
tar xvf procps-ng-3.3.17.tar.xz
cd procps-ng-3.3.17

./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill

make
make check
make install