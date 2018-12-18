Build from buildroot
====================

  $ git clone https://gitlab.com/c-sky/buildroot.git
  $ cd buildroot
  $ git checkout <buildroot-version>
  $ make <buildroot-config>
  $ make

Result of the build
-------------------

    output/images/
    ├── csky_buildroot_version.txt (Contain version details)
    ├── <buildroot-config>_<buildroot-version>.tar.xz
    ├── linux-<kernel-version>.patch.xz
    ├── qemu.dtb
    ├── rootfs.cpio.xz
    └── vmlinux.xz

How to Run
==========

Download all files above.

  $ xz -d vmlinux.xz
  $ mkdir toolchain
  $ cd toolchain
  $ tar -Jxf ../<buildroot-config>_<buildroot-version>.tar.xz
  $ cd ..
  $ toolchain/csky-qemu/bin/qemu-system-csky2 -kernel vmlinux -dtb qemu_smp.dtb -nographic -M mp860 -smp 4

Run with network

  You need setup tap0 in your host PC first, and then execute:

  $ toolchain/csky-qemu/bin/qemu-system-csky2 -kernel vmlinux -dtb qemu.dtb -nographic -M virt -net nic -net tap,ifname=tap0

Build linux kernel
==================

Download the clean kernel source from kernel.org

  $ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz
  $ tar -Jxf linux-<kernel-version>.tar.xz

  $ xz -d rootfs.cpio.xz
  $ xz -d linux-<kernel-version>.patch.xz

Patch linux kernel

  $ cd linux-<kernel-version>
  $ patch -p1 < ../linux-<kernel-version>.patch

Build linux kernel

  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=../toolchain/bin/csky-linux- vmlinux
