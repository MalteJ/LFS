#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/libcap.html

set -e
set -x

cd /sources
rm -rf libcap-2.63
tar xvf libcap-2.63.tar.xz
cd libcap-2.63

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

make test

make prefix=/usr lib=lib install
