#!/bin/bash -i
basename "$0"
source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1

set -e
set -x

cd $LFS/sources
tar xvf linux-5.15.59.tar.xz
cd linux-5.15.59

make mrproper

make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr
