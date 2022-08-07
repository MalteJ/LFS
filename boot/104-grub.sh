#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter10/grub.html

set -e
set -x

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext4
set root=(hd0,1)

menuentry "GNU/Linux, Linux 5.15.59-lfs-11.1" {
        linux   /boot/vmlinuz-5.15.59-lfs-11.1 root=UUID=8b681c2f-a5fa-498d-8ffa-2aa5016d32fc ro
}
EOF