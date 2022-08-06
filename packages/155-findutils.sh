#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/findutils.html

set -e
set -x

cd /sources
rm -rf findutils-4.9.0
tar xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0

case $(uname -m) in
    i?86)   TIME_T_32_BIT_OK=yes ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
    x86_64) ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
esac

make

chown -Rv tester .
su tester -c "PATH=$PATH make check"

make install
