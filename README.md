Metal Linux from Scratch
========================

Based on the great work of Gerard Beekmans on [Linux from Scratch](https://www.linuxfromscratch.org/).

Licensed under [MIT License](LICENSE).

How does LFS work?
------------------

Linux from Scratch has multiple build steps. In a first step a cross-compiler will be built (chapters 1-6 - `make toolchain`). This happens from your host machine. To finish the setup of the cross compiler you will chroot into the new filesystem (chapter 7 - `make chroot`).

In a next step packages to be used later on will be built within the chroot environment (chapter 8 - `make packages`). Finally system configuration (chapter 9) and building a kernel and bootloader will be done (chapter 10 - `make kernel && make boot`).


Build instructions
------------------

To create the intermediate filesystem `artifacts/lfs-temp-tools-11.1.tar` execute the `toolchain`, `mount` and `chroot` Make targets. `make mount` will mount virtual filesystems into the chroot environment (/dev, /proc, /sys, /run etc.). These can be unmounted using `make unmount`.

    make toolchain    # LFS chapter 6
    make mount
    make chroot       # LFS chapter 7


`make chroot` will write out tar file. For the the virtual filesystems will be unmounted. You have to mount them again before you proceed with building packages:

    make mount
    make packages     # LFS chapter 8


The glibc tests will have 2 fails: `io/tst-lchmod` and `misc/tst-ttyname`. That's standard LFS behaviour. Simply start `make packages` again and glibc will be built successfully.

    make packages     # 2nd time after glibc showed 2 (unimportant) tests fail


Building the kernel and bootloader have individual make targets:

    make kernel       # LFS chapter 10
    make boot         # LFS chapter 9, 10


You can unmount virtual filesystem mounts using

    make unmount

