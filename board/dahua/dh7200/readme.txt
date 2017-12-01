C-SKY Development Kit

Intro
=====

dh7200 SOC is from http://www.dahuatech.com

How to build it
===============

  $ make csky_dh7200_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── vmlinux
    ├── rootfs.tar
    ├── rootfs.cpio
    └── dh7200.dtb

Run with initramfs
==================

1. Run DebugServer

  $ cd output/host/csky-debug
  $ ./DebugServerConsole.elf -ddc -port 1025

  (console will show a gdbint example, like this: target jtag jtag://127.0.0.1:1025)

2. Check the gdbinit, the IP and Port must be the same as above.

  $ cd output/images
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/dahua/dh7200/gdbinit vmlinux

