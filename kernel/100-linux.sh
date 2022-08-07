#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter10/kernel.html

set -e
set -x

echo KERNEL_VERSION=$KERNEL_VERSION
if [ -z $KERNEL_VERSION ]; then exit 1; fi

cd /sources
tar xf linux-$KERNEL_VERSION.tar.xz
cd linux-$KERNEL_VERSION

make mrproper

# make defconfig
cp /lfs/kernel/linux-$KERNEL_VERSION.config .config

make -j24
make modules_install

cp -v arch/x86/boot/bzImage /boot/vmlinuz-$KERNEL_VERSION-lfs-11.1
cp -v System.map /boot/System.map-$KERNEL_VERSION
cp -v .config /boot/config-$KERNEL_VERSION

## docs:
# install -d /usr/share/doc/linux-$KERNEL_VERSION
# cp -r Documentation/* /usr/share/doc/linux-$KERNEL_VERSION
