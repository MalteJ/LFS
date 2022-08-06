#!/bin/bash -i
basename "$0"
source ~/.bashrc

set -e
set -x

USER=`whoami`

sudo chown -v $USER $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) sudo chown -v $USER $LFS/lib64 ;;
esac
