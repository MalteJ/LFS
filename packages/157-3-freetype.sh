#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/general/freetype2.html

set -e
set -x

cd /sources
rm -rf freetype-2.11.1
tar xvf freetype-2.11.1.tar.xz
cd freetype-2.11.1

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&


./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install


rm -rf /sources/freetype-2.11.1