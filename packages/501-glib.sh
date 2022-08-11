#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/general/glib2.html

set -e
set -x

cd /sources
rm -rf glib-2.70.4
tar xvf glib-2.70.4.tar.xz
cd glib-2.70.4

patch -Np1 -i ../glib-2.70.4-skip_warnings-1.patch

mkdir build
cd    build

meson --prefix=/usr       \
      --buildtype=release \
      ..
ninja

ninja install

mkdir -p /usr/share/doc/glib-2.70.4
cp -r ../docs/reference/{gio,glib,gobject} /usr/share/doc/glib-2.70.4

