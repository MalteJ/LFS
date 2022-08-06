#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/iproute2.html

set -e
set -x

cd /source
rm -rf iproute2-5.16.0
tar xvf iproute2-5.16.0.tar.xz
cd iproute2-5.16.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make
make SBINDIR=/usr/sbin install

## docs:
# mkdir -pv             /usr/share/doc/iproute2-5.16.0
# cp -v COPYING README* /usr/share/doc/iproute2-5.16.0