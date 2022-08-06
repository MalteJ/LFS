#!/bin/bash -i
basename "$0"
source ~/.bashrc

set -e
set -x

cd $LFS/sources
tar xvf gzip-1.11.tar.xz
cd gzip-1.11

./configure --prefix=/usr --host=$LFS_TGT

make

make DESTDIR=$LFS install

