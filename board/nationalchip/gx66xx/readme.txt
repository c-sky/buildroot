C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

gx66xx develop board is made by Hangzhou Nationalchip and C-SKY.

gx6605s Hardware Spec:
  * CPU: ck610 up to 594Mhz
  * Integrate with 64MB ddr2 in SOC.
  * Integrate with hardware Jtag.
  * Integrate with usb-to-serial chip.
  * USB ehci controller in SOC.
  * Power Supply: DC 5V from two micro-usb.

How to build it
===============

  $ make csky_gx6605s_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── boot.vfat
    ├── gx6605s.dtb
    ├── gx6622.dtb
    ├── rootfs.ext2
    ├── rootfs.ext4
    ├── rootfs.tar
    ├── usb.img
    └── uImage

How to run it with usb drive
============================

Prepare the bootable usb drive
------------------------------

Copy the bootable "usb.img" onto an USB drive with "dd":

  $ sudo umount /dev/sd[X][1,2,3...]
  $ sudo dd if=output/images/usb.img of=/dev/sd[X]

Where sd[X] is the device node of the entire USB drive.
Eg: sda sdb sdc... not partition!

Run
---

1. Insert the USB in the dev board.
2. Setup the console with the rate 115200/8-N-1.
3. Power On.

How to run it with jtag
=======================

1. Run DebugServer

  $ cd output/host/csky-debug
  $ sudo ./DebugServerConsole.elf -ddc -rstwait 1000 -prereset -port 1025

  (console will show a gdbint example, like this: target jtag jtag://127.0.0.1:1025)

2. Check the gdbinit, the IP and Port must be the same as above.

  $ cd output/images
  $ ../host/usr/bin/csky-linux-gdb -x ../../board/nationalchip/gx66xx/gdbinit ../build/<linux-kernel-dir>/vmlinux

