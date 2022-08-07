#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/blfs/view/stable/postlfs/efibootmgr.html

set -e
set -x

cd /sources
rm -rf efibootmgr-17
tar xvf efibootmgr-17.tar.gz
cd efibootmgr-17

# Built with instructions from BLFS:

sed -e '/extern int efi_set_verbose/d' -i src/efibootmgr.c
sed 's/-Werror//' -i Make.defaults

make EFIDIR=LFS EFI_LOADER=grubx64.efi
make install EFIDIR=LFS


rm -rf /sources/efibootmgr-17