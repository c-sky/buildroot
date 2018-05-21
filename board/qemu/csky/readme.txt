Build from buildroot
====================

  $ git clone https://github.com/c-sky/buildroot.git
  $ cd buildroot
  $ make qemu_csky_ck807f_4.16_glibc_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── csky_toolchain_qemu_csky_ck807f_4.16_glibc_defconfig_<commit-id>.tar.xz
    ├── linux-4.16.2.patch.xz
    ├── qemu.dtb
    ├── rootfs.cpio.xz
    └── vmlinux.xz

How to Run
==========

  $ <csky_toolchain dir>/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic

  - qemu-system-cskyv2 is from "tar -Jxf csky_toolchain_<...>.tar.xz"
  - vmlinux is from "xz -d vmlinux.xz"

Run with network
================

  You need setup tap0 in your host PC, then execute:

  $ <csky_toolchain dir>/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic -net nic -net tap,ifname=tap0

Build kernel alone
==================

  - Download the clean kernel source from kernel.org
  $ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.2.tar.xz
  $ tar -Jxf linux-4.16.2.tar.xz

  $ xz -d rootfs.cpio.xz
  $ xz -d linux-4.16.2.patch.xz

  - patch and make
  $ cd linux-4.16.2
  $ patch -p1 < ../linux-4.16.2.patch
  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=<csky_toolchain dir>/bin/csky-linux- vmlinux

