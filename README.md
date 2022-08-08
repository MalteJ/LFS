Metal Linux from Scratch
========================

Based on the great work of Gerard Beekmans on [Linux from Scratch](https://www.linuxfromscratch.org/lfs/view/stable/).

Licensed under [MIT License](LICENSE).

How does LFS work?
------------------

Linux from Scratch has multiple build steps. In a first step a cross-compiler will be built (chapters 1-7 - `make toolchain`).

In a next step packages to be used later on will be built within a chroot environment (chapter 8 - `make packages`). Finally system configuration (chapter 9) and building a kernel and bootloader will be done (chapter 10 - `make kernel && make boot`).


Build instructions
------------------

Run `make all` and wait for a few hours until you will find a finished `artifacts/disk.img`. Alternatively:

We will build the toolchain using a docker container, that has the required build tools installed. To create the docker container execute

    make docker


The build system will install LFS in the `build` directory. Because we want to have a bootable image later on, we will create a block device as raw file, partition it and mount to to `build`.
As the system should be booted using UEFI, we will set up an EFI partition and mount it to `build/boot/efi`. The block device will be saved at `artifacts/disk.img`. Disk creation and mount is automated using `make disk`:

    make disk


You may check the details of the newly created raw image file:

    $ ls -lh artifacts/disk.img
    -rw-r--r-- 1 lfs lfs 17179869184  8. Aug 01:29 artifacts/disk.img

    $ fdisk -l artifacts/disk.img
    Disk artifacts/disk.img: 16 GiB, 17179869184 bytes, 33554432 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: gpt
    Disk identifier: 84649940-5CC0-4B3E-A145-8FB7EB20FF42

    Device               Start      End  Sectors  Size Type
    artifacts/disk.img1   2048   206847   204800  100M EFI System
    artifacts/disk.img2 206848 33552383 33345536 15,9G Linux filesystem


Next, we build the toolchain ([chapter 6](https://www.linuxfromscratch.org/lfs/view/stable/chapter06/chapter06.html) & [chapter 7](https://www.linuxfromscratch.org/lfs/view/stable/chapter07/chapter07.html)):

    make mount-vfs    # mount virtual kernel filesystems into build/ (proc, sys etc.)
    make sources      # downloads all source packages to build/sources (see misc/wget-list.*)
    make toolchain    # LFS chapter 6 & 7

Now is a good time to backup the new toolchain to a tar file:

    make unmount
    mkdir -p artifacts
    cd build
    sudo tar cpfv ../artifacts/lfs-temp-tools-11.1.tar .


You have to mount the virtual filesystems again before you proceed with building packages ([chapter 8](https://www.linuxfromscratch.org/lfs/view/stable/chapter08/chapter08.html)):

    make mount-vfs
    make packages     # LFS chapter 8


Building the kernel and bootloader have individual make targets ([chapter 9](https://www.linuxfromscratch.org/lfs/view/stable/chapter09/chapter09.html) & [chapter 10](https://www.linuxfromscratch.org/lfs/view/stable/chapter10/chapter10.html)):

    make kernel       # LFS chapter 10
    make boot         # LFS chapter 9, 10


To chroot into your LFS system execute

    make chroot


Before doing anything with your raw image, you should unmount it and all virtual filesystems:

    make unmount-all


#### Mount related make targets

##### make disk

Deletes if existing the old disk `artifacts/disk.img`. Creates a new disk, partitions it and mounts it to `build` and its EFI partition to `build/boot/efi`.

##### make mount-vfs

Mounts virtual kernel filesystems (proc, sys etc.) to `build/{proc,sys,...}`.


##### make mount-disk

Mounts `artifacts/disk.img` to `build` and `build/boot/efi`. This is also already included in `make disk`.


##### make unmount

Unmounts virtual kernel filesystems.


##### make unmount-all

Unmounts all virtual kernel filesystems, `build/boot/efi` as well as `build`. Afterwards you can do stuff with your `artifacts/disk.img`.
Basically this make target executes `sudo umount -Rv build && sudo losetup -D`.

#### Automated Build Tests

A few tests will fail, which is standard with LFS. For reference you can compare with [LFS Test Logs](https://www.linuxfromscratch.org/lfs/build-logs/11.1/Xeon-E5-1650v3/test-logs/) if your test results are to be expected.

To be able to build our image without interruption, we have disabled the tests of the following packages by commenting out the `make check` or `make test` calls:

* packages
  * 103-glibc.sh
  * 120-attr.sh
  * 124-gcc.sh
  * 127-sed.sh
  * 133-libtool.sh
  * 151-1-e2fsprogs.sh
  * 164-tar.sh
  * 166-vim.sh
  * 169-procps-ng.sh
  * 170-util-linux.sh


Running LFS as Libvirt Qemu/KVM Guest
-------------------------------------

For development purposes a VM can be created, mounting the just assembled LFS image `artifacts/disk.img`.

    make virt-start
    
    # You can now connect via VNC to port 5900


To destroy and undefine the VM execute:

    make virt-stop



Changes over upstream LFS
-------------------------

* Kernel 5.15.59 instead of 5.16.9
* Grub is built [with UEFI à la BLFS](https://www.linuxfromscratch.org/blfs/view/stable/postlfs/grub-efi.html)
* OpenSSL 3.0.5 instead of 3.0.1
* e2fsprogs (`151-1-e2fsprogs.sh`) will be built before coreutils (`151-2-coreutils.sh`) to provide `mkfs.ext2`, which coreutils needs for its tests.
* Disabled a few tests (see Tests)
* Disabled installation of lots of docs


Kernel
------

We are using the latest LTS kernel version instead of a mainline kernel like upstream LFS.

See also [LFS Kernel Page](https://www.linuxfromscratch.org/lfs/view/stable/chapter10/kernel.html).


TODO
----

* Kernel version is currently hardcoded in multiple places (e.g. `Makefile`, `kernel/*`, `toolchain/103-linux.sh`)
* Have a look at the [LFS-Bootscripts](https://www.linuxfromscratch.org/lfs/view/stable/chapter09/bootscripts.html). They install config files for sysvinit with network configuration etc. This has to be adapted to our needs.
* Remove packages we do not need
* Remove build system from final image
* Reduce Kernel functionality to a minimum
* Include Qemu
