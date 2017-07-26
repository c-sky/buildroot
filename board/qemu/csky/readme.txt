C-SKY Development Kit

Intro
=====

C-SKY QEMU, how to build and run.

For ck810
=========

  $ make qemu_csky_ck810_uclibc_defconfig
  $ make

  $ cd output/images
  $ ../host/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel vmlinux -dtb ck810.dtb -nographic

For ck610
=========

  $ make qemu_csky_ck610_uclibc_defconfig
  $ make

  $ cd output/images
  $ ../host/csky-qemu/bin/qemu-system-cskyv1 -machine virt -kernel vmlinux -dtb ck610.dtb -nographic


