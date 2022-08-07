#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter10/fstab.html

set -e
set -x

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options               dump  fsck
#                                                                order

UUID=8b681c2f-a5fa-498d-8ffa-2aa5016d32fc   /              ext4  defaults            1     1
proc           /proc        proc     nosuid,noexec,nodev   0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev   0     0
devpts         /dev/pts     devpts   gid=5,mode=620        0     0
tmpfs          /run         tmpfs    defaults              0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid      0     0
efivarfs       /sys/firmware/efi/efivars efivarfs defaults 0     0


# End /etc/fstab
EOF