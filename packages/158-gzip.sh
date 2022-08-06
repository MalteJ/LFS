#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/gzip.html

set -e
set -x

cd /sources
rm -rf gzip-1.11
tar xvf gzip-1.11.tar.xz
cd gzip-1.11

