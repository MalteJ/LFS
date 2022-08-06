#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo __NOT_IMPLEMENTED

set -e
set -x

cd /sources
rm -rf sed-4.8
tar xvf sed-4.8.tar.xz
cd sed-4.8

./configure --prefix=/usr
make
#make html

chown -Rv tester .
su tester -c "PATH=$PATH make check"

make install
install -d -m755           /usr/share/doc/sed-4.8
#install -m644 doc/sed.html /usr/share/doc/sed-4.8