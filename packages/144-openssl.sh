#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/openssl.html

set -e
set -x

cd /source
rm -rf openssl-3.0.1
tar xjvf openssl-3.0.1.tar.gz
cd openssl-3.0.1

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make
make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.0.1

## docs:
#cp -vfr doc/* /usr/share/doc/openssl-3.0.1
