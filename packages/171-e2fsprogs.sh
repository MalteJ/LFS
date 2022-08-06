#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/e2fsprogs.html

set -e
set -x

cd /source
rm -rf e2fsprogs-1.46.5
tar xvf e2fsprogs-1.46.5.tar.gz
cd e2fsprogs-1.46.5

mkdir -v build
cd       build

../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck

make
make check
make install

rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info


## docs:
# makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
# install -v -m644 doc/com_err.info /usr/share/info
# install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info