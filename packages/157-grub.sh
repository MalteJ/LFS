#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo __NOT_IMPLEMENTED

set -e
set -x

cd /sources
rm -rf grub-2.06
tar xvf grub-2.06.tar.xz
cd grub-2.06

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions