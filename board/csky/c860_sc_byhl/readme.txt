Build from buildroot
====================

  $ git clone https://github.com/c-sky/buildroot.git
  $ cd buildroot
  $ make csky_c860_sc_byhl_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── c860_sc_byhl.dtb
    ├── linux-4.9.56.patch.xz
    ├── rootfs.cpio
    ├── gdbinit
    └── vmlinux

How to Run
==========

Check the gdbinit, the IP and Port must be the same as DebugServer.

  $ <csky_toolchain dir>/bin/csky-linux-gdb -x gdbinit vmlinux

  - csky-linux-gdb is from "tar -Jxf csky_toolchain_<...>.tar.xz"
  - gdbinit is the Jtag Server connect init script

Build kernel fast
=================

  - Download the clean kernel source from kernel.org.
  $ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.2.tar.xz
  $ tar -Jxf linux-4.9.56.tar.xz

  $ xz -d rootfs.cpio.xz
  $ xz -d linux-4.9.56.patch.xz

  - patch and make
  $ cd linux-4.9.56
  $ patch -p1 < ../linux-4.9.56.patch
  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=<csky_toolchain dir>/bin/csky-linux- vmlinux

