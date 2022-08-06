#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/zstd.html

set -e
set -x

cd /source
tar xjvf zstd-1.5.2.tar.gz
cd zstd-1.5.2

make
make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a
