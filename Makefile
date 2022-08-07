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

partition:
	rm -f artifacts/part.img
	dd if=/dev/zero of=artifacts/part.img
	sudo mkfs.ext4 artifacts/part.img
	sudo tune2fs artifacts/part.img -U 8b681c2f-a5fa-498d-8ffa-2aa5016d32fc
	sudo blkid artifacts/part.img

	mkdir -p build
	sudo mount artifacts/part.img build

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
	sudo unmount -Rv build

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
	wget https://github.com/rhboot/efivar/releases/download/38/efivar-38.tar.bz2 -o build/sources/efivar-38.tar.bz2
	wget https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz -o build/sources/efibootmgr-17.tar.gz
	wget https://downloads.sourceforge.net/freetype/freetype-2.11.1.tar.xz -o build/sources/freetype-2.11.1.tar.xz

	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make _boot"

all: toolchain mount chroot packages kernel boot unmount-all