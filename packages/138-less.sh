#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/less.html

set -e
set -x

cd /sources
rm -rf less-590
tar xvf less-590.tar.gz
cd less-590

./configure --prefix=/usr --sysconfdir=/etc
make
make install