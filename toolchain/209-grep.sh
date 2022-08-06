#!/bin/bash -i
basename "$0"
source ~/.bashrc

set -e
set -x

cd $LFS/sources
tar xvf grep-3.7.tar.xz
cd grep-3.7

./configure --prefix=/usr   \
            --host=$LFS_TGT

make

make DESTDIR=$LFS install

