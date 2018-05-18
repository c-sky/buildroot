Build from buildroot
====================

  $ git clone https://github.com/c-sky/buildroot.git
  $ cd buildroot
  $ make csky_ck860_platform_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── ck860_platform.dtb
    ├── csky_toolchain_csky_ck860_platform_defconfig_<commit-id>.tar.xz
    ├── linux-4.16.2.patch.xz
    ├── rootfs.cpio.xz
    ├── gdbinit
    └── vmlinux.xz

How to Run
==========

Check the gdbinit, the IP and Port must be the same as DebugServer.

  $ <csky_toolchain dir>/bin/csky-linux-gdb -x gdbinit vmlinux

  - csky-linux-gdb is from "tar -Jxf csky_toolchain_<...>.tar.xz"
  - gdbinit is the Jtag Server connect init script
  - vmlinux is from "xz -d vmlinux.xz"

Build kernel fast
=================

  - Download the clean kernel source from kernel.org.
  $ xz -d rootfs.cpio.xz
  $ xz -d linux-4.16.2.patch.xz
  $ tar -Jxf linux-4.16.2.tar.xz

  - patch and make
  $ cd linux-4.16.2
  $ patch -p1 < ../linux-4.16.2.patch
  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=<csky_toolchain dir>/bin/csky-linux- vmlinux

