#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/general/pixman.html

set -e
set -x

cd /sources
rm -rf pixman-0.40.0
tar xvf pixman-0.40.0.tar.gz
cd pixman-0.40.0

mkdir build
cd    build

meson --prefix=/usr --buildtype=release
ninja
ninja install