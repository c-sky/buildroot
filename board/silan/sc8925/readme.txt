C-SKY Development Kit

Intro
=====

sc8925 SOC is from http://www.silan.com.cn

How to build it
===============

  $ make csky_sc8925_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── vmlinux
    ├── rootfs.tar
    ├── rootfs.cpio
    └── sc8925.dtb

Run with initramfs
==================

1. Run DebugServer

  $ cd output/host/csky-debug
  $ ./DebugServerConsole.elf -ddc -port 1025

  (console will show a gdbint example, like this: target jtag jtag://127.0.0.1:1025)

2. Check the gdbinit, the IP and Port must be the same as above.

  $ cd output/images
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/silan/sc8925/gdbinit vmlinux


Run with NFS rootfs
===================

1. Prepare the nfs-server on your linux PC. You can get the step in google, we
   don't mention it here.

   Then extract output/images/rootfs.tar to your nfs root.

2. Modified the "bootargs=" in board/silan/sc8925/sc8925.dts'. You must
   specify the correct nfsroot= and ip= by your own PC enviornment.

3. Make menuconfig deselect buildroot "filesystem->initramfs"

4. Make linux-menuconfig deselect "General Setup->initramfs"
 
  '$ make linux-rebuild' again to update the output/images


