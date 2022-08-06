#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/gawk.html

set -e
set -x

cd /source
rm -rf gawk-5.1.1
tar xvf gawk-5.1.1.tar.xz
cd gawk-5.1.1

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make check
make install

## docs
# mkdir -pv                                   /usr/share/doc/gawk-5.1.1
# cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1