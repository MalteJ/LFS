#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/postlfs/grub-efi.html

set -e
set -x

cd /sources
rm -rf grub-2.06
tar xvf grub-2.06.tar.xz
cd grub-2.06

# Built with instructions from BLFS:
# https://www.linuxfromscratch.org/blfs/view/stable/postlfs/grub-efi.html

mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-14.0.01.pcf.gz > /usr/share/fonts/unifont/unifont.pcf

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     &&
unset TARGET_CC &&

make

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions