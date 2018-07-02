C-SKY Development Kit

How to build it
===============
use CSKY company net, then

  $ make csky_eragon2_scpu_evb_gerrit_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── eragon2_scpu_evb.dtb
    ├── media-partition.ext2
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
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/csky/eragon2_scpu_evb/gdbinit ../build/<linux-kernel-dir>/vmlinux

