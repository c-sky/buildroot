C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

trilobite develop board is made by Hangzhou Nationalchip and C-SKY.

Hardware Spec:
  * CPU: ck610/ck810/ck807

How to build it, take ck810 as an example
===============

  $ make qemu_ck810_defconfig
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

1. Download csky-qemu:

  https://???

2. Config tap0 on linux host:

  modify /etc/network/interfaces:

    auto lo
    iface lo inet loopback

    +auto br0
    +iface br0 inet static
    +bridge_ports eth0 tap0
    +address 172.16.28.35
    +netmask 255.255.255.0
    +gateway 172.16.28.254

3. Go to the csky-qemu directory:

  ck810:
  $ sudo ./bin/cskysim -soc soccfg/cskyv2/trilobite_810f_cfg.xml -kernel <buildroot-dir>/output/build/<linux-kernel-dir>/vmlinux -cpu ck810 -gdb tcp::12345 -net nic -net tap,ifname=tap0 -nographic -S

  ck610:
  $ sudo ./bin/cskysim -soc soccfg/cskyv1/trilobite_610em_cfg.xml -kernel <buildroot-dir>/output/build/<linux-kernel-dir>/vmlinux -cpu ck610 -gdb tcp::12345 -net nic -net tap,ifname=tap0 -nographic -S

  ck807:
  $ sudo ./bin/cskysim -soc soccfg/cskyv2/trilobite_807_cfg.xml -kernel <buildroot-dir>/output/build/<linux-kernel-dir>/vmlinux -cpu ck807 -gdb tcp::12345 -net nic -net tap,ifname=tap0 -nographic -S

4. Check the gdbinit, the IP and Port must be the same as above.

  $ cd output/images/
  $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/qemu/csky/gdbinit ../build/<linux-kernel-dir>/vmlinux

