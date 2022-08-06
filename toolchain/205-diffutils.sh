#!/bin/bash -i
basename "$0"
source ~/.bashrc

set -e
set -x

cd $LFS/sources
tar xvf diffutils-3.8.tar.xz
cd diffutils-3.8

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

