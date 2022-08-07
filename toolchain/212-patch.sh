#!/bin/bash -i
basename "$0"
source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1

set -e
set -x

cd $LFS/sources
tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

