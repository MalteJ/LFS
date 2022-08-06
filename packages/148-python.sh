#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo __NOT_IMPLEMENTED

set -e
set -x

cd /sources
rm -rf Python-3.10.2
tar xvf Python-3.10.2.tar.xz
cd Python-3.10.2

./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --with-ensurepip=yes \
            --enable-optimizations

make
make install

## docs:
# install -v -dm755 /usr/share/doc/python-3.10.2/html
# tar --strip-components=1  \
#     --no-same-owner       \
#     --no-same-permissions \
#     -C /usr/share/doc/python-3.10.2/html \
#     -xvf ../python-3.10.2-docs-html.tar.bz2