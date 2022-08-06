#!/bin/bash -i
[ `whoami` = root ] || exec sudo $0
basename "$0"
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter07/changingowner.html

source ~/.bashrc
set -e
set -x

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac