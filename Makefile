KERNEL_VERSION=5.15.59

SHELL = /bin/bash -o pipefail

TOOLCHAIN := $(wildcard toolchain/*.sh)
TOOLCHAIN_LOGS := $(TOOLCHAIN:.sh=.log)

CHROOT := $(wildcard chroot/*.sh)
CHROOT_OUT := $(CHROOT:.sh=.out)

PACKAGES := $(wildcard packages/*.sh)
PACKAGES_OUT := $(PACKAGES:.sh=.out)

KERNEL := $(wildcard kernel/*.sh)
KERNEL_OUT := $(KERNEL:.sh=.out)

BOOT := $(wildcard boot/*.sh)
BOOT_OUT := $(BOOT:.sh=.out)


.PHONY: toolchain chroot packages kernel boot packages/010-test.out 
#packages/877-stripping.sh packages/878-cleanup.sh

%.log: %.sh
	MAKEFLAGS='-j24' $< | sudo tee $@

%.out: %.sh
	MAKEFLAGS='-j24' $< | tee $@

tc: $(TOOLCHAIN_LOGS)


clean:
	sudo umount -Rv build; sudo rm -rf build
	sudo rm -f toolchain/*.log
	sudo rm -f chroot/*.out
	sudo rm -f packages/*.out
	sudo rm -f kernel/*.out
	sudo rm -f boot/*.out
	sudo rm -f artifacts/part.img

docker:
	docker build -t onmetal/lfs-builder .

var:
	export FOO=$(shell echo bar); echo foo$${FOO}p2

disk:
	rm -f artifacts/disk.img
	dd if=/dev/zero of=artifacts/disk.img bs=1M count=16384
	parted artifacts/disk.img mklabel gpt mkpart "EFI" fat32 1MiB 101MiB set 1 esp on mkpart "Linux" ext4 101MiB 100%
	export DEVICE=$(shell sudo losetup -f artifacts/disk.img --partscan --show); \
	sudo mkfs.vfat $${DEVICE}p1; \
	sudo mkfs.ext4 $${DEVICE}p2; \
	sudo tune2fs $${DEVICE}p2 -U 8b681c2f-a5fa-498d-8ffa-2aa5016d32fc; \
	sudo mkdir -p build2; \
	sudo mount $${DEVICE}p2 build2; \
	sudo mkdir -p build2/efi; \
	sudo mount $${DEVICE}p1 build2/efi


toolchain:
	docker run -it --rm -v '$(shell pwd):/mnt/lfs' onmetal/lfs-builder make tc

mount:
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

unmount:
	sudo umount build/dev/pts
	sudo umount build/{sys,proc,run,dev}
	sudo umount build/lfs

unmount-all:
	sudo umount -Rv build
	sudo losetup -D

_chroot: $(CHROOT_OUT)

chroot:
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _chroot"
	

_packages: $(PACKAGES_OUT)

packages:
	# additional packages for grub's efi support (packages/157-*.sh)
	[ -f build/sources/mandoc-1.14.6.tar.gz ]                 || wget https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz -O build/sources/mandoc-1.14.6.tar.gz
	[ -f build/sources/efivar-38.tar.bz2 ]      || wget https://github.com/rhboot/efivar/releases/download/38/efivar-38.tar.bz2 -O build/sources/efivar-38.tar.bz2
	[ -f build/sources/efibootmgr-17.tar.gz ]   || wget https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz -O build/sources/efibootmgr-17.tar.gz
	[ -f build/sources/freetype-2.11.1.tar.xz ] || wget https://downloads.sourceforge.net/freetype/freetype-2.11.1.tar.xz -O build/sources/freetype-2.11.1.tar.xz
	[ -f build/sources/unifont-14.0.01.pcf.gz ] || wget http://unifoundry.com/pub/unifont/unifont-14.0.01/font-builds/unifont-14.0.01.pcf.gz -O build/sources/unifont-14.0.01.pcf.gz
	

	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _packages"

_kernel: $(KERNEL_OUT)

kernel:
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$(KERNEL_VERSION).tar.xz -O build/sources/linux-$(KERNEL_VERSION).tar.xz

	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && KERNEL_VERSION=$(KERNEL_VERSION) make _kernel"

_boot: $(BOOT_OUT)

boot:
	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _boot"

all: toolchain mount chroot packages kernel boot unmount-all


qemu:
	qemu-system-x86_64 \
	  -m 2048M \
	  -smp 2 \
	  -cpu host \
	  -boot c \
	  -drive format=raw,file=artifacts/disk.img \
	  -vga std \
	  -machine type=q35,accel=kvm \
	  -smbios "type=0,vendor=0vendor,version=0version,date=0date,release=0.0,uefi=on" \
	  -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 \
	  -display gtk
