#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter09/bootscripts.html

set -e
set -x

cd /sources
tar xvf lfs-bootscripts-20210608.tar.xz
cd lfs-bootscripts-20210608

make install
