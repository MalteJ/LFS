#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/man-pages.html

set -e
set -x

cd /sources
rm -rf man-pages-5.13
tar xvf man-pages-5.13.tar.xz
cd man-pages-5.13

make prefix=/usr install
