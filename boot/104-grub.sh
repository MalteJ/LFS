#!/bin/bash -i
basename "$0"
if [ ! `id -u` = 0 ]; then echo "Script has to run as root!"; exit 1; fi
echo https://www.linuxfromscratch.org/lfs/view/stable/chapter10/grub.html

set -e
set -x

mkdir -p /boot/grub

# set root=(hd0,gpt2)
# search --no-floppy --fs-uuid --set 8b681c2f-a5fa-498d-8ffa-2aa5016d32fc

cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2

if loadfont /boot/grub/fonts/unicode.pf2; then
  set gfxmode=auto
  insmod all_video
  terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 5.15.59-lfs-11.1" {
        linux   /boot/vmlinuz-5.15.59-lfs-11.1 root=/dev/vda2 ro console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200
}

menuentry "Firmware Setup" {
  fwsetup
}
EOF

grub-install --bootloader-id=LFS --recheck --efi-directory=/boot/efi --boot-directory=/boot --removable
