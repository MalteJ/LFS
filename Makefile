KERNEL_VERSION=5.15.59

SHELL = /bin/bash -o pipefail

TOOLCHAIN := $(wildcard toolchain/*.sh)
TOOLCHAIN_LOGS := $(TOOLCHAIN:.sh=.log)

CHROOT := $(wildcard toolchain/chrooted/*.sh)
CHROOT_OUT := $(CHROOT:.sh=.out)

PACKAGES := $(wildcard packages/*.sh)
PACKAGES_OUT := $(PACKAGES:.sh=.out)

KERNEL := $(wildcard kernel/*.sh)
KERNEL_OUT := $(KERNEL:.sh=.out)

BOOT := $(wildcard boot/*.sh)
BOOT_OUT := $(BOOT:.sh=.out)


.PHONY: toolchain chroot packages kernel boot packages/010-test.out kernel/100-linux.sh boot/104-grub.sh
#packages/877-stripping.sh packages/878-cleanup.sh

%.log: %.sh
	MAKEFLAGS='-j24' $< | sudo tee $@

%.out: %.sh
	MAKEFLAGS='-j24' $< | tee $@

tc: $(TOOLCHAIN_LOGS)


clean:
	sudo umount -Rv build; sudo rm -rf build
	sudo rm -f toolchain/*.log
	sudo rm -f toolchain/chrooted/*.out
	sudo rm -f packages/*.out
	sudo rm -f kernel/*.out
	sudo rm -f boot/*.out
	sudo losetup -D
	sudo rm -f artifacts/disk.img

docker:
	cd misc && docker build -t onmetal/lfs-builder .

var:
	export FOO=$(shell echo bar); echo foo$${FOO}p2

disk:
	rm -f artifacts/disk.img
	dd if=/dev/zero of=artifacts/disk.img bs=1M count=16384
	sudo sfdisk artifacts/disk.img < misc/partitions.fdisk

	make _disk

_disk:
	export DEVICE=$(shell sudo losetup -f artifacts/disk.img --partscan --show); \
	sudo mkfs.vfat -F 32 $${DEVICE}p1; \
	sudo mkfs.ext4 $${DEVICE}p2; \
	sudo mkdir -p build; \
	sudo mount $${DEVICE}p2 build; \
	sudo mkdir -p build/boot/efi; \
	sudo mount $${DEVICE}p1 build/boot/efi

toolchain:
	docker run -it --rm -v '$(shell pwd):/mnt/lfs' onmetal/lfs-builder make tc

	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _chrooted"

mount-vfs:
	sudo mkdir -pv build/{dev,proc,sys,run}

	[ -d build/dev/console ] || sudo mknod -m 600 build/dev/console c 5 1; echo ok
	[ -d build/dev/null ] || sudo mknod -m 666 build/dev/null c 1 3; echo ok

	sudo mount -v --bind /dev build/dev

	sudo mount -v --bind /dev/pts build/dev/pts
	sudo mount -vt proc proc build/proc
	sudo mount -vt sysfs sysfs build/sys
	sudo mount -vt tmpfs tmpfs build/run

	if [ -h build/dev/shm ]; then \
		sudo mkdir -pv build/$(readlink $LFS/dev/shm); \
	fi

	sudo mkdir -p build/lfs
	sudo mount --bind $(shell pwd) build/lfs

mount-disk:
	export DEVICE=$(shell sudo losetup -f artifacts/disk.img --partscan --show); \
	sudo mkdir -p build; \
	sudo mount $${DEVICE}p2 build; \
	sudo mkdir -p build/boot/efi; \
	sudo mount $${DEVICE}p1 build/boot/efi

sources:
	sudo rm -rf build/sources
	sudo mkdir -p build/sources
	sudo chmod 777 build/sources
	wget -nv --input-file=misc/wget-list.custom --directory-prefix=build/sources
	wget -nv --input-file=misc/wget-list.blfs --directory-prefix=build/sources
	wget -nv --input-file=misc/wget-list.lfs --directory-prefix=build/sources

unmount:
	sudo umount build/dev/pts
	sudo umount build/{sys,proc,run,dev}
	sudo umount build/lfs

unmount-all:
	sudo umount -Rv build
	sudo losetup -D
	sudo losetup -l

_chrooted: $(CHROOT_OUT)

chroot:
	sudo chroot build /usr/bin/env -i \
		HOME=/root                    \
		PWD=/root                     \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w$$ '   \
		PATH=/usr/bin:/usr/sbin       \
		/bin/bash -i
	

_packages: $(PACKAGES_OUT)

packages:
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _packages"

_kernel: $(KERNEL_OUT)

kernelconfig:
	sudo cp kernel/linux-5.15.59.config build/sources/linux-5.15.59/.config
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /sources/linux-5.15.59/ && make menuconfig"

	cp build/sources/linux-5.15.59/.config kernel/linux-5.15.59.config

kernel:
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && KERNEL_VERSION=$(KERNEL_VERSION) make _kernel"

	sudo cp build/boot/vmlinuz-* artifacts

initramfs:
	cd build/ && sed "s#^/##" ../misc/initramfs | cpio -cov | zstd -3 > ../artifacts/initramfs.zst

_boot: $(BOOT_OUT)

boot:
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _boot"

all: disk mount-vfs sources toolchain packages kernel boot unmount-all

virsh-start:
	sed 's#__PWD__#$(PWD)#' misc/libvirt.xml > artifacts/libvirt.xml
	
	virsh --connect qemu:///system create artifacts/libvirt.xml

virsh-stop:
	virsh --connect qemu:///system destroy LFS; \
	virsh --connect qemu:///system undefine --nvram LFS

virsh-console:
	virsh --connect qemu:///system console LFS
