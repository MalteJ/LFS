#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/xml-parser.html

set -e
set -x

cd /source
rm -rf XML-Parser-2.46
tar xvf XML-Parser-2.46.tar.gz
cd XML-Parser-2.46

perl Makefile.PL
make
make test
make install