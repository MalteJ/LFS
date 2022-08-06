#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/iana-etc.html

set -e
set -x

cd /sources
tar xzvf iana-etc-20220207.tar.gz
cd iana-etc-20220207

cp services protocols /etc