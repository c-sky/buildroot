C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

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
    └── sc8925.dtb

Prepare NFS rootfs
==================

1. Prepare the nfs-server on your linux PC. You can get the step in google, we
   don't mention it here.

   Then extract output/images/rootfs.tar to your nfs root.

2. Modified the "bootargs=" in board/csky/sc8925/sc8925.dts'. You must
   specify the correct nfsroot= and ip= by your own PC enviornment.

   '$ make linux-rebuild' again to update the sc8925.dtb in output/images

How to run it with jtag
=======================

1. Download the Jtag-Server here:

  https://github.com/c-sky/tools/raw/master/DebugServerConsole-linux-x86_64-V4.2.00-20161213.tar.gz

2. Go to the unpacked directory:

  $./DebugServerConsole.elf -ddc -rstwait 1000 -prereset -port 1025

  (Perhaps you need to use "sudo", which need libusb to detect c510:b210)

  $ sudo ./DebugServerConsole.elf -ddc -rstwait 1000 -prereset -port 1025

  (console will show a gdbint example, like this: target jtag jtag://127.0.0.1:1025)

3. Check the gdbinit, the IP and Port must be the same as above.

  $ cd output/images
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/csky/sc8925/gdbinit vmlinux


