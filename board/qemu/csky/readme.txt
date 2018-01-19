C-SKY Qemu Tips

Intro
=====

Teach you how to run csky qemu.

Quick Start
===========

  $ make qemu_csky_ck610_uclibc_defconfig
  $ make

  $ cd output/images
  $ ../host/csky-qemu/bin/qemu-system-cskyv1 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic

Use gdb debug vmlinux
=====================

  $ cd output/images
  $ ../host/csky-qemu/bin/qemu-system-cskyv1 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic -s -S

  Now qemu is waiting for gdb connection with 127.0.0.1:1234

  $ ../host/bin/csky-linux-gdb vmlinux
  (gdb) tar remote :1234
  (gdb) c

  gdb will connect the qemu with 127.0.0.1:1234

