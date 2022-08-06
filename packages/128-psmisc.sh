#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/psmisc.html

set -e
set -x

cd /source
rm -rf psmisc-23.4
tar xvf psmisc-23.4.tar.xz
cd psmisc-23.4

./configure --prefix=/usr
make
make install