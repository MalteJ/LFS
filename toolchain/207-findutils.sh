#!/bin/bash -i
basename "$0"
source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1

set -e
set -x

cd $LFS/sources
tar xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

