C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

trilobite develop board is made by Hangzhou Nationalchip and C-SKY.

Hardware Spec:
  * CPU: ck610/ck810/ck807

How to build it, eg: 810
========================

  $ make qemu_csky_ck810_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── ck810.dtb
    ├── rootfs.cpio
    ├── rootfs.tar
    └── vmlinux

How to run it with csky-qemu
============================

1. Run Qemu

  $ cd output/host/csky-qemu
  $ sudo bin/cskysim -cpu ck810 -soc soccfg/cskyv2/trilobite_810f_cfg.xml -kernel ../../images/vmlinux -gdb tcp::12345 -nographic -S

2. Check the gdbinit, the Port must be the same as above.

  $ cd output/images
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/qemu/csky/gdbinit_810 vmlinux

About the cskysim args
----------------------

  1. -cpu: ck610/ck807/ck810

  2. -soc:	soccfg/cskyv1/trilobite_610em_cfg.xml
		soccfg/cskyv2/trilobite_807_cfg.xml
		soccfg/cskyv2/trilobite_810f_cfg.xml

  3. for ck610: pls use gdbinit_610

Connect to host network
=======================

Config tap0 on linux host
-------------------------

   modify /etc/network/interfaces:

   auto lo
   iface lo inet loopback

   +auto br0
   +iface br0 inet static
   +bridge_ports eth0 tap0
   +address 172.16.28.35
   +netmask 255.255.255.0
   +gateway 172.16.28.254

Change the cskysim command like this
------------------------------------

  $ sudo bin/cskysim -cpu ck810 -soc soccfg/cskyv2/trilobite_810f_cfg.xml -kernel ../../images/vmlinux -gdb tcp::12345 -nographic -S -net nic -net tap,ifname=tap0

