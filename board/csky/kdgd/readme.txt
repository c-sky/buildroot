C-SKY Development Kit

How to build it
===============

  $ make csky_kdgd_defconfig
  $ make

Or use CSKY company net, then

  $ make csky_kdgd_gerrit_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── kdgd.dtb
    ├── rootfs.cpio
    ├── rootfs.tar
    ├── spl_uboot.bin
    ├── u-boot.bin
    ├── u-boot-spl.bin
    └── uImage

Run with initramfs
==================

Check the gdbinit, the IP and Port must be the same as DebugServer.

  $ cd output/images
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/csky/kdgd/gdbinit ../build/<linux-kernel-dir>/vmlinux

