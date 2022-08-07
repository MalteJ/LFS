#!/bin/bash -i
basename "$0"
source ~/.bashrc
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
popd
