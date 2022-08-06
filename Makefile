SHELL = /bin/bash -o pipefail

TOOLCHAIN := $(wildcard toolchain/*.sh)
TOOLCHAIN_LOGS := $(TOOLCHAIN:.sh=.log)

CHROOT := $(wildcard chroot/*.sh)
CHROOT_OUT := $(CHROOT:.sh=.out)

.PHONY: toolchain chroot

%.log: %.sh
	MAKEFLAGS='-j8' $< | sudo tee $@

%.out: %.sh
	MAKEFLAGS='-j8' $< | tee $@

tc: $(TOOLCHAIN_LOGS)

chrooted: $(CHROOT_OUT)

clean:
	sudo umount build; sudo rm -rf build; sudo rm -f toolchain/*.log

toolchain:
	docker run -it --rm -v '$(shell pwd):/mnt/lfs' onmetal/lfs-builder make tc

chroot:
	sudo mkdir -pv build/{dev,proc,sys,run}

	sudo mknod -m 600 build/dev/console c 5 1
	sudo mknod -m 666 build/dev/null c 1 3

	sudo mount -v --bind /dev build/dev

	sudo mount -v --bind /dev/pts build/dev/pts
	sudo mount -vt proc proc build/proc
	sudo mount -vt sysfs sysfs build/sys
	sudo mount -vt tmpfs tmpfs build/run

	if [ -h build/dev/shm ]; then \
		sudo mkdir -pv build/$(readlink $LFS/dev/shm); \
	fi

	sudo mkdir -p build/lfs
	sudo cp -ra Makefile chroot build/lfs/

	sudo chroot build /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$(TERM)"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/usr/bin:/usr/sbin     \
		/bin/bash --login -c "cd /lfs && make chrooted"
	
	make unmount

	mkdir -p artifacts
	cd build && sudo tar -cpfv ../artifacts/lfs-temp-tools-11.1.tar .

unmount:
	sudo umount build/dev/pts
	sudo umount build/{sys,proc,run,dev}

docker:
	docker build -t onmetal/lfs-builder .
