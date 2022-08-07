#!/bin/bash -i
basename "$0"
source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1

set -e
set -x

if [ -z "$LFS" ]; then echo "LFS variable not set"; exit 1; fi

sudo mkdir -p $LFS/sources
sudo chmod -v a+wt $LFS/sources

#wget https://www.linuxfromscratch.org/lfs/view/11.1/md5sums -P $LFS/sources/

#wget https://www.linuxfromscratch.org/lfs/view/11.1/wget-list -P $LFS/sources/
#wget --input-file=$LFS/sources/wget-list --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
  wget -qO- http://ftp.lfs-matrix.net/pub/lfs/lfs-packages/lfs-packages-11.1.tar | tar xv
  cd 11.1/
  md5sum -c md5sums
  mv * ../
  cd ..

  # download newer OpenSSL
  wget https://www.openssl.org/source/openssl-3.0.5.tar.gz

	# additional packages for grub's efi support (packages/157-*.sh)
  wget https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz -O mandoc-1.14.6.tar.gz
  wget https://github.com/rhboot/efivar/releases/download/38/efivar-38.tar.bz2 -O efivar-38.tar.bz2
  wget http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz -O popt-1.18.tar.gz
  wget https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz -O efibootmgr-17.tar.gz
  wget https://downloads.sourceforge.net/freetype/freetype-2.11.1.tar.xz -O freetype-2.11.1.tar.xz
  wget http://unifoundry.com/pub/unifont/unifont-14.0.01/font-builds/unifont-14.0.01.pcf.gz -O unifont-14.0.01.pcf.gz
	
popd
