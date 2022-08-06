#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/kbd.html

set -e
set -x

cd /sources
rm -rf kbd-2.4.0
tar xvf kbd-2.4.0.tar.xz
cd kbd-2.4.0

patch -Np1 -i ../kbd-2.4.0-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make
make check
make install

## docs:
# mkdir -pv           /usr/share/doc/kbd-2.4.0
# cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0