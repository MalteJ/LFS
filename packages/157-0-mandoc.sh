#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
https://www.linuxfromscratch.org/blfs/view/systemd/general/mandoc.html
set -e
set -x

cd /sources
rm -rf mandoc-1.14.6
tar xvf mandoc-1.14.6.tar.gz
cd mandoc-1.14.6

# Built with instructions from BLFS:

./configure
make mandoc

install -vm755 mandoc   /usr/bin
install -vm644 mandoc.1 /usr/share/man/man1

rm -rf /sources/mandoc-1.14.6