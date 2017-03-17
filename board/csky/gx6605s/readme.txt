C-SKY Development Kit

Intro
=====

Gx6605s SOC is from HangZhou Nationalchip, and with C-SKY CPU inside.

www.c-sky.com

How to build it
===============

  $ make csky_gx6605s_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── boot.vfat
    ├── .gdbinit
    ├── gx6605s.dtb
    ├── rootfs.ext2
    ├── rootfs.ext4
    ├── rootfs.tar
    ├── usb.img
    └── zImage

How to run it with usb drive
============================

Once the build process is finished you will have an image called "usb.img"
in the output/images/ directory.

Copy the bootable "usb.img" onto an USB drive with "dd":

  $ sudo dd if=output/images/usb.img of=/dev/sdX

Where /dev/sdX is the device node of your USB drive.

Insert the USB in the dev board, setup the console with the
rate 115200/8-N-1. Power On.

How to run it with jtag
=======================

1. Prepare Jtag-Server:

   https://github.com/c-sky/tools/raw/master/DebugServerConsole-linux-x86_64-V4.2.00-20161213.sh

   install it:
   sudo ./DebugServerConsole-linux-x86_64-V4.2.00-20161213.sh -i

2. run it:

   $ DebugServerConsole -ddc -rstwait 1000 -prereset -port 1025

   It will display ip and port for your gdb to connect, eg:

   target jtag jtag://127.0.0.1:1025

   Please remember the DebugServer IP address and port which displayed above.
   Check the output/images/.gdbinit on first line, they must be the same.

   $ cd output/images
   $ csky-linux-gdb vmlinux

Finish
======

Any question contact me here:

ren_guo@c-sky.com

-----------
Best Regards

Guo Ren

