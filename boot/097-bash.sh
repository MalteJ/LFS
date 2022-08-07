#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter09/profile.html

set -e
set -x

cat > /etc/profile << "EOF"
# Begin /etc/profile

# End /etc/profile
EOF