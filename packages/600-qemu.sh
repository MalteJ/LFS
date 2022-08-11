#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/man-pages.html

set -e
set -x

cd /sources
rm -rf qemu-6.2.0
tar xvf qemu-6.2.0.tar.xz
cd qemu-6.2.0

# usermod -a -G kvm myuser

QEMU_ARCH=x86_64-softmmu

mkdir -vp build
cd        build

../configure --prefix=/usr               \
             --sysconfdir=/etc           \
             --localstatedir=/var        \
             --target-list=$QEMU_ARCH    \
             --docdir=/usr/share/doc/qemu-6.2.0

unset QEMU_ARCH

make

make install

cat > /lib/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660"
EOF

chgrp kvm  /usr/libexec/qemu-bridge-helper
chmod 4750 /usr/libexec/qemu-bridge-helper
