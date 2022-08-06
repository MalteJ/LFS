#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/bc.html

set -e
set -x

cd /source
tar xvf bc-5.2.2.tar.xz
cd bc-5.2.2

CC=gcc ./configure --prefix=/usr -G -O3
make
make test
make install