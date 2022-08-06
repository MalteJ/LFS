#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter08/texinfo.html

set -e
set -x

cd /source
rm -rf texinfo-6.8
tar xvf texinfo-6.8.tar.xz
cd texinfo-6.8

./configure --prefix=/usr

sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c

make
make check
make install

make TEXMF=/usr/share/texmf install-tex

## The Info documentation system uses a plain text file to hold its list of menu entries.
## The file is located at /usr/share/info/dir. Unfortunately, due to occasional problems
## in the Makefiles of various packages, it can sometimes get out of sync with the info pages
## installed on the system. If the /usr/share/info/dir file ever needs to be recreated, the
## following optional commands will accomplish the task:
#
# pushd /usr/share/info
#   rm -v dir
#   for f in *
#     do install-info $f dir 2>/dev/null
#   done
# popd