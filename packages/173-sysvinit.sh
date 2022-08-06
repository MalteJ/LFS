#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/sysvinit.html

set -e
set -x

cd /sources
rm -rf sysvinit-3.01
tar xvf sysvinit-3.01.tar.xz
cd sysvinit-3.01


patch -Np1 -i ../sysvinit-3.01-consolidated-1.patch

make

make install