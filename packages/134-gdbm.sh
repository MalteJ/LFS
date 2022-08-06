#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/gdbm.html

set -e
set -x

cd /source
rm -rf gdbm-1.23
tar xvf gdbm-1.23.tar.gz
cd gdbm-1.23

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make
make check
make install
