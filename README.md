Metal Linux from Scratch
========================

Based on the great work of Gerard Beekmans on [Linux from Scratch](https://www.linuxfromscratch.org/).

Licensed under [MIT License](LICENSE).


Build instructions
------------------

To create the intermediate filesystem `artifacts/lfs-temp-tools-11.1.tar` execute the `toolchain`, `mount` and `chroot` Make targets:

    make toolchain    # LFS chapter 6
    make mount
    make chroot       # LFS chapter 7


Then build packages and kernel:

    make packages     # LFS chapter 8
    make kernel       # LFS chapter 10
    make boot         # LFS chapter 9, 10


You can unmount virtual filesystem mounts using

    make unmount

