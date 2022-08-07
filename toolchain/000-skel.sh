#!/bin/bash -i
#[ `whoami` = root ] || exec sudo $0
basename "$0"
echo LFS_DOCS_URL

source ~/.bashrc
[ -z $LFS ] && echo "ERROR: LFS env var is empty" && exit 1
set -e
set -x

export