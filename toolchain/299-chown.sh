#!/bin/bash -i
basename "$0"
source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1

echo https://www.linuxfromscratch.org/lfs/view/stable/chapter07/changingowner.html


set -e
set -x

sudo chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) sudo chown -R root:root $LFS/lib64 ;;
esac